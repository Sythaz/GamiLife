import 'package:flutter/material.dart';
import '../../data/models/progress_model.dart';

// Pure functions untuk validasi progress
// Semua function mengembalikan String? (null = valid, String = error message)
class ProgressValidator {
  // Validasi deskripsi tidak boleh kosong
  static String? validateDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return 'Please fill in the description';
    }
    return null;
  }

  // Validasi link harus berupa URL valid dengan http/https
  static String? validateLink(String? link) {
    if (link == null || link.trim().isEmpty) {
      return null; // Link optional, null = valid
    }

    final linkText = link.trim();
    final isValidUrl = Uri.tryParse(linkText)?.hasScheme ?? false;
    final hasHttpScheme =
        linkText.startsWith('http://') || linkText.startsWith('https://');

    if (!isValidUrl || !hasHttpScheme) {
      return 'Please enter a valid URL (must start with http:// or https://)';
    }
    return null;
  }

  // Validasi date tidak boleh null untuk activity
  static String? validateActivityDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    return null;
  }

  // Validasi time tidak boleh null untuk activity
  static String? validateActivityTime(TimeOfDay? time) {
    if (time == null) {
      return 'Please select a time';
    }
    return null;
  }

  // Validasi minimal 1 skill untuk activity
  static String? validateActivitySkills(List<String>? skills) {
    if (skills == null || skills.isEmpty) {
      return 'Please select at least one skill';
    }
    return null;
  }

  // Validasi date tidak boleh null untuk todo
  static String? validateTodoDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    return null;
  }

  // Validasi time tidak boleh null untuk todo
  static String? validateTodoTime(TimeOfDay? time) {
    if (time == null) {
      return 'Please select a time';
    }
    return null;
  }

  // Cek apakah weekly summary sudah ada di minggu ini
  static bool hasWeeklySummaryThisWeek(List<ProgressModel> allProgress) {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 (Monday) - 7 (Sunday)

    // Hitung Senin minggu ini
    final monday = now.subtract(Duration(days: weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);

    // Hitung Minggu minggu ini
    final sunday = monday.add(const Duration(days: 6));
    final endOfWeek = DateTime(
      sunday.year,
      sunday.month,
      sunday.day,
      23,
      59,
      59,
    );

    return allProgress.any((progress) {
      if (progress.type != ProgressType.summary) return false;
      if (progress.isSummaryWeekly != true) return false;
      if (progress.date == null) return false;

      return progress.date!.isAfter(
            startOfWeek.subtract(const Duration(seconds: 1)),
          ) &&
          progress.date!.isBefore(endOfWeek.add(const Duration(seconds: 1)));
    });
  }

  // Cek apakah daily summary sudah ada hari ini
  static bool hasDailySummaryToday(List<ProgressModel> allProgress) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return allProgress.any((progress) {
      if (progress.type != ProgressType.summary) return false;
      if (progress.isSummaryWeekly == true) return false;
      if (progress.date == null) return false;

      return progress.date!.isAfter(
            today.subtract(const Duration(seconds: 1)),
          ) &&
          progress.date!.isBefore(endOfToday.add(const Duration(seconds: 1)));
    });
  }
}
