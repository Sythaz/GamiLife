// Karena kita memiliki 2 mode, sehingga kita deklarasikan enum dahulu
import 'package:flutter/material.dart';

enum TimerMode { popular, custom }

// Class untuk helper / model agar dapat menyimpan informasi sesi timer lebih mudah
class TimerSession {
  final Duration duration;
  final String label;
  final bool isWork;
  late final IconData icon = isWork
      ? Icons.emoji_objects_outlined
      : Icons.local_cafe;

  TimerSession({
    required this.duration,
    required this.label,
    required this.isWork,
  });

  static TimerSession work({
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    String label = 'Stay productive!',
  }) {
    return TimerSession(
      duration: Duration(hours: hours, minutes: minutes, seconds: seconds),
      label: label,
      isWork: true,
    );
  }

  static TimerSession breakSession({
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    String label = 'Short Break!',
  }) {
    return TimerSession(
      duration: Duration(hours: hours, minutes: minutes, seconds: seconds),
      label: label,
      isWork: false,
    );
  }
}
