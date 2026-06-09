import 'dart:async';

import '../models/progress_model.dart';
import '../dummy/dummy_progress_data.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  factory IsarService() => _instance;

  final List<ProgressModel> _storage = [];
  final StreamController<List<ProgressModel>> _controller =
      StreamController<List<ProgressModel>>.broadcast();

  int _nextId = 1;

  IsarService._internal() {
    if (_storage.isEmpty) {
      _storage.addAll(DummyProgressData.activities);
      _nextId = DummyProgressData.activities.length + 1;
    }
  }

  void _emit() {
    final items = List<ProgressModel>.from(_storage)
      ..sort((a, b) {
        if (a.date == null && b.date == null) {
          return b.createdAt.compareTo(a.createdAt);
        }
        if (a.date == null) return 1;
        if (b.date == null) return -1;

        final dateCompare = b.date!.compareTo(a.date!);
        if (dateCompare != 0) return dateCompare;

        return b.createdAt.compareTo(a.createdAt);
      });
    if (!_controller.isClosed) {
      _controller.add(items);
    }
  }

  // Create - Tambah progress baru
  Future<int> addProgress(ProgressModel progress) async {
    final stored = ProgressModel(
      id: progress.id == 0 ? _nextId++ : progress.id,
      type: progress.type,
      isSummaryWeekly: progress.isSummaryWeekly,
      description: progress.description,
      link: progress.link,
      skills: progress.skills == null
          ? null
          : List<String>.from(progress.skills!),
      skillsPoint: progress.skillsPoint == null
          ? null
          : Map<String, int>.from(progress.skillsPoint!),
      date: progress.date,
      time: progress.time,
      isNotificationEnabled: progress.isNotificationEnabled,
    );
    stored.createdAt = progress.createdAt;
    _storage.add(stored);
    _emit();
    return stored.id;
  }

  // Read - Ambil semua progress
  Future<List<ProgressModel>> getAllProgress() async {
    final items = List<ProgressModel>.from(_storage)
      ..sort((a, b) {
        if (a.date == null && b.date == null) {
          return b.createdAt.compareTo(a.createdAt);
        }
        if (a.date == null) return 1;
        if (b.date == null) return -1;

        final dateCompare = b.date!.compareTo(a.date!);
        if (dateCompare != 0) return dateCompare;

        return b.createdAt.compareTo(a.createdAt);
      });
    return items;
  }

  // Read - Ambil progress berdasarkan type
  Future<List<ProgressModel>> getProgressByType(ProgressType type) async {
    final items = await getAllProgress();
    return items.where((item) => item.type == type).toList();
  }

  // Read - Ambil progress berdasarkan tanggal
  Future<List<ProgressModel>> getProgressByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final items = await getAllProgress();
    return items.where((item) {
      final itemDate = item.date;
      if (itemDate == null) return false;
      return !itemDate.isBefore(startOfDay) && !itemDate.isAfter(endOfDay);
    }).toList();
  }

  // Update - Update progress
  Future<void> updateProgress(ProgressModel progress) async {
    final index = _storage.indexWhere((item) => item.id == progress.id);
    if (index == -1) return;
    _storage[index] = progress;
    _emit();
  }

  // Delete - Hapus progress
  Future<bool> deleteProgress(int id) async {
    final before = _storage.length;
    _storage.removeWhere((item) => item.id == id);
    final removed = _storage.length < before;
    if (removed) _emit();
    return removed;
  }

  // Delete - Hapus semua progress
  Future<void> deleteAllProgress() async {
    _storage.clear();
    _emit();
  }

  // Stream - Listen perubahan data
  Stream<List<ProgressModel>> watchAllProgress() async* {
    yield await getAllProgress();
    yield* _controller.stream;
  }

  Stream<List<ProgressModel>> watchProgressByType(ProgressType type) async* {
    yield await getProgressByType(type);
    yield* _controller.stream.map(
      (items) => items.where((item) => item.type == type).toList(),
    );
  }
}
