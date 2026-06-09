import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/progress_model.dart';
import '../../data/services/isar_service.dart';
import '../enums/enums_button_category.dart';

// Provider untuk IsarService (singleton)
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

// StreamProvider yang watch semua progress dari Isar
final allProgressStreamProvider = StreamProvider<List<ProgressModel>>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return isarService.watchAllProgress();
});

// StateProvider untuk category filter
final activityCategoryProvider = StateProvider<ActivityCategory>((ref) {
  return ActivityCategory.all;
});

// StateProvider untuk date filter
final dateFilterProvider = StateProvider<DateTime?>((ref) {
  return null;
});

// StateProvider untuk search query
final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

// Provider untuk filtered progress list (computed state)
final filteredProgressProvider = Provider<List<ProgressModel>>((ref) {
  // Watch all progress stream
  final progressAsync = ref.watch(allProgressStreamProvider);

  // Return empty list jika masih loading atau error
  final allProgress = progressAsync.maybeWhen(
    data: (data) => data,
    orElse: () => <ProgressModel>[],
  );

  // Get filter values
  final category = ref.watch(activityCategoryProvider);
  final dateFilter = ref.watch(dateFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  var filtered = allProgress;

  // Filter by category
  if (category != ActivityCategory.all) {
    ProgressType type;
    switch (category) {
      case ActivityCategory.activity:
        type = ProgressType.activity;
        break;
      case ActivityCategory.summary:
        type = ProgressType.summary;
        break;
      case ActivityCategory.todo:
        type = ProgressType.todo;
        break;
      default:
        type = ProgressType.activity;
    }
    filtered = filtered.where((p) => p.type == type).toList();
  }

  // Filter by date
  if (dateFilter != null) {
    filtered = filtered.where((p) {
      if (p.date == null) return false;
      return p.date!.year == dateFilter.year &&
          p.date!.month == dateFilter.month &&
          p.date!.day == dateFilter.day;
    }).toList();
  }

  // Filter by search query
  if (searchQuery.isNotEmpty) {
    final searchLower = searchQuery.toLowerCase();
    filtered = filtered.where((p) {
      return p.description.toLowerCase().contains(searchLower);
    }).toList();
  }

  return filtered;
});
