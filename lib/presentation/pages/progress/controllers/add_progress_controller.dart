import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/enums_button_category.dart';
import '../../../../core/validators/progress_validator.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../data/models/progress_model.dart';
import '../../../../data/services/isar_service.dart';

// State untuk menyimpan data form add progress
class AddProgressState {
  final AddProgressActivityCategory currentCategory;
  final bool isSaving;
  final String? errorMessage;

  // Activity fields
  final String activityDescription;
  final String activityLink;
  final DateTime? activityDate;
  final TimeOfDay? activityTime;
  final List<String> activitySkills;
  final Map<String, int> activitySkillsPoint;

  // Summary fields
  final String summaryDescription;
  final String summaryLink;
  final bool isSummaryWeekly;

  // Todo fields
  final String todoDescription;
  final String todoLink;
  final DateTime? todoDate;
  final TimeOfDay? todoTime;
  final bool isNotificationEnabled;

  const AddProgressState({
    this.currentCategory = AddProgressActivityCategory.activity,
    this.isSaving = false,
    this.errorMessage,
    this.activityDescription = '',
    this.activityLink = '',
    this.activityDate,
    this.activityTime,
    this.activitySkills = const [],
    this.activitySkillsPoint = const {},
    this.summaryDescription = '',
    this.summaryLink = '',
    this.isSummaryWeekly = false,
    this.todoDescription = '',
    this.todoLink = '',
    this.todoDate,
    this.todoTime,
    this.isNotificationEnabled = false,
  });

  AddProgressState copyWith({
    AddProgressActivityCategory? currentCategory,
    bool? isSaving,
    String? errorMessage,
    String? activityDescription,
    String? activityLink,
    DateTime? activityDate,
    TimeOfDay? activityTime,
    List<String>? activitySkills,
    Map<String, int>? activitySkillsPoint,
    String? summaryDescription,
    String? summaryLink,
    bool? isSummaryWeekly,
    String? todoDescription,
    String? todoLink,
    DateTime? todoDate,
    TimeOfDay? todoTime,
    bool? isNotificationEnabled,
  }) {
    return AddProgressState(
      currentCategory: currentCategory ?? this.currentCategory,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      activityDescription: activityDescription ?? this.activityDescription,
      activityLink: activityLink ?? this.activityLink,
      activityDate: activityDate ?? this.activityDate,
      activityTime: activityTime ?? this.activityTime,
      activitySkills: activitySkills ?? this.activitySkills,
      activitySkillsPoint: activitySkillsPoint ?? this.activitySkillsPoint,
      summaryDescription: summaryDescription ?? this.summaryDescription,
      summaryLink: summaryLink ?? this.summaryLink,
      isSummaryWeekly: isSummaryWeekly ?? this.isSummaryWeekly,
      todoDescription: todoDescription ?? this.todoDescription,
      todoLink: todoLink ?? this.todoLink,
      todoDate: todoDate ?? this.todoDate,
      todoTime: todoTime ?? this.todoTime,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }
}

// Controller untuk handle business logic add progress
class AddProgressController extends StateNotifier<AddProgressState> {
  final IsarService _isarService;

  AddProgressController(this._isarService) : super(const AddProgressState());

  // Update kategori yang dipilih
  void setCategory(AddProgressActivityCategory category) {
    state = state.copyWith(currentCategory: category);
  }

  // Update activity description
  void setActivityDescription(String description) {
    state = state.copyWith(activityDescription: description);
  }

  // Update activity link
  void setActivityLink(String link) {
    state = state.copyWith(activityLink: link);
  }

  // Update activity date
  void setActivityDate(DateTime date) {
    state = state.copyWith(activityDate: date);
  }

  // Update activity time
  void setActivityTime(TimeOfDay time) {
    state = state.copyWith(activityTime: time);
  }

  // Update activity skills
  void setActivitySkills(List<String> skills, Map<String, int> skillsPoint) {
    state = state.copyWith(
      activitySkills: skills,
      activitySkillsPoint: skillsPoint,
    );
  }

  // Update summary description
  void setSummaryDescription(String description) {
    state = state.copyWith(summaryDescription: description);
  }

  // Update summary link
  void setSummaryLink(String link) {
    state = state.copyWith(summaryLink: link);
  }

  // Update summary weekly flag
  void setSummaryWeekly(bool isWeekly) {
    state = state.copyWith(isSummaryWeekly: isWeekly);
  }

  // Update todo description
  void setTodoDescription(String description) {
    state = state.copyWith(todoDescription: description);
  }

  // Update todo link
  void setTodoLink(String link) {
    state = state.copyWith(todoLink: link);
  }

  // Update todo date
  void setTodoDate(DateTime date) {
    state = state.copyWith(todoDate: date);
  }

  // Update todo time
  void setTodoTime(TimeOfDay time) {
    state = state.copyWith(todoTime: time);
  }

  // Update notification enabled
  void setNotificationEnabled(bool enabled) {
    state = state.copyWith(isNotificationEnabled: enabled);
  }

  // Validasi dan simpan progress
  // Return null jika sukses, String error message jika gagal
  Future<String?> saveProgress() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // Get current data based on category
      final description = _getCurrentDescription();
      final link = _getCurrentLink();

      // Validasi umum
      final descriptionError = ProgressValidator.validateDescription(
        description,
      );
      if (descriptionError != null) {
        state = state.copyWith(isSaving: false, errorMessage: descriptionError);
        return descriptionError;
      }

      final linkError = ProgressValidator.validateLink(link);
      if (linkError != null) {
        state = state.copyWith(isSaving: false, errorMessage: linkError);
        return linkError;
      }

      // Validasi khusus per kategori
      String? validationError;
      switch (state.currentCategory) {
        case AddProgressActivityCategory.activity:
          validationError = await _validateActivity();
          break;
        case AddProgressActivityCategory.summary:
          validationError = await _validateSummary();
          break;
        case AddProgressActivityCategory.todo:
          validationError = await _validateTodo();
          break;
      }

      if (validationError != null) {
        state = state.copyWith(isSaving: false, errorMessage: validationError);
        return validationError;
      }

      // Buat model dan simpan
      final progress = _buildProgressModel();
      final progressId = await _isarService.addProgress(progress);

      // Schedule notification untuk todo jika enabled
      if (state.currentCategory == AddProgressActivityCategory.todo &&
          state.isNotificationEnabled &&
          state.todoDate != null &&
          state.todoTime != null) {
        await _scheduleTodoNotification(progressId, progress);
      }

      state = state.copyWith(isSaving: false);
      return null; // Sukses
    } catch (e) {
      final errorMsg = 'Failed to save progress: $e';
      state = state.copyWith(isSaving: false, errorMessage: errorMsg);
      return errorMsg;
    }
  }

  // Helper: Schedule notification untuk todo
  Future<void> _scheduleTodoNotification(
    int progressId,
    ProgressModel progress,
  ) async {
    try {
      // Combine date + time jadi DateTime
      final scheduledDateTime = DateTime(
        state.todoDate!.year,
        state.todoDate!.month,
        state.todoDate!.day,
        state.todoTime!.hour,
        state.todoTime!.minute,
      );

      await NotificationService().scheduleTodoNotification(
        id: progressId,
        title: '📌 Todo Reminder',
        description: progress.description,
        scheduledDate: scheduledDateTime,
      );
    } catch (e) {
      // Log error tapi jangan block save
      print('⚠️ Failed to schedule notification: $e');
    }
  }

  // Helper: Get current description based on category
  String _getCurrentDescription() {
    switch (state.currentCategory) {
      case AddProgressActivityCategory.activity:
        return state.activityDescription;
      case AddProgressActivityCategory.summary:
        return state.summaryDescription;
      case AddProgressActivityCategory.todo:
        return state.todoDescription;
    }
  }

  // Helper: Get current link based on category
  String _getCurrentLink() {
    switch (state.currentCategory) {
      case AddProgressActivityCategory.activity:
        return state.activityLink;
      case AddProgressActivityCategory.summary:
        return state.summaryLink;
      case AddProgressActivityCategory.todo:
        return state.todoLink;
    }
  }

  // Validasi khusus untuk activity
  Future<String?> _validateActivity() async {
    // Validasi date
    final dateError = ProgressValidator.validateActivityDate(
      state.activityDate,
    );
    if (dateError != null) return dateError;

    // Validasi time
    final timeError = ProgressValidator.validateActivityTime(
      state.activityTime,
    );
    if (timeError != null) return timeError;

    // Validasi skills
    final skillsError = ProgressValidator.validateActivitySkills(
      state.activitySkills,
    );
    if (skillsError != null) return skillsError;

    return null;
  }

  // Validasi khusus untuk summary
  Future<String?> _validateSummary() async {
    final allProgress = await _isarService.getAllProgress();

    if (state.isSummaryWeekly) {
      // Cek weekly summary
      if (ProgressValidator.hasWeeklySummaryThisWeek(allProgress)) {
        // Reset flag jika sudah ada
        state = state.copyWith(isSummaryWeekly: false);
        return 'You have already saved a weekly summary this week!';
      }
    } else {
      // Cek daily summary
      if (ProgressValidator.hasDailySummaryToday(allProgress)) {
        return 'You have already saved a daily summary today!';
      }
    }

    return null;
  }

  // Validasi khusus untuk todo
  Future<String?> _validateTodo() async {
    // Validasi date
    final dateError = ProgressValidator.validateTodoDate(state.todoDate);
    if (dateError != null) return dateError;

    // Validasi time
    final timeError = ProgressValidator.validateTodoTime(state.todoTime);
    if (timeError != null) return timeError;

    return null;
  }

  // Build ProgressModel dari state
  ProgressModel _buildProgressModel() {
    ProgressType type;
    switch (state.currentCategory) {
      case AddProgressActivityCategory.activity:
        type = ProgressType.activity;
        break;
      case AddProgressActivityCategory.summary:
        type = ProgressType.summary;
        break;
      case AddProgressActivityCategory.todo:
        type = ProgressType.todo;
        break;
    }

    return ProgressModel(
      type: type,
      description: _getCurrentDescription().trim(),
      link: _getCurrentLink().trim().isEmpty ? null : _getCurrentLink().trim(),
      skills: state.currentCategory == AddProgressActivityCategory.activity
          ? (state.activitySkills.isEmpty ? null : state.activitySkills)
          : null,
      skillsPoint: state.currentCategory == AddProgressActivityCategory.activity
          ? (state.activitySkillsPoint.isEmpty
                ? null
                : state.activitySkillsPoint)
          : null,
      date: _getCurrentDate(),
      time: _getCurrentTimeString(),
      isNotificationEnabled:
          state.currentCategory == AddProgressActivityCategory.todo
          ? state.isNotificationEnabled
          : null,
      isSummaryWeekly:
          state.currentCategory == AddProgressActivityCategory.summary
          ? state.isSummaryWeekly
          : null,
    );
  }

  // Helper: Get current date based on category
  DateTime? _getCurrentDate() {
    switch (state.currentCategory) {
      case AddProgressActivityCategory.activity:
        return state.activityDate;
      case AddProgressActivityCategory.summary:
        return DateTime.now(); // Summary always use current datetime
      case AddProgressActivityCategory.todo:
        return state.todoDate;
    }
  }

  // Helper: Get current time as string based on category
  String? _getCurrentTimeString() {
    TimeOfDay? time;
    switch (state.currentCategory) {
      case AddProgressActivityCategory.activity:
        time = state.activityTime;
        break;
      case AddProgressActivityCategory.summary:
        time = TimeOfDay.now(); // Summary always use current time
        break;
      case AddProgressActivityCategory.todo:
        time = state.todoTime;
        break;
    }

    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// Provider untuk AddProgressController
final addProgressControllerProvider =
    StateNotifierProvider.autoDispose<AddProgressController, AddProgressState>((
      ref,
    ) {
      final isarService = ref.watch(Provider((ref) => IsarService()));
      return AddProgressController(isarService);
    });
