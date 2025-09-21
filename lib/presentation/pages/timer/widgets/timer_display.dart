import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import '../../../../core/constants/colors.dart';
import '../helpers/format_duration.dart';

class TimerDisplayWidget extends StatelessWidget {
  final bool _isRunning;
  final DateTime? _timerEndTime;
  final Duration _remaining;
  final VoidCallback? onTap;

  const TimerDisplayWidget({
    super.key,
    required bool isRunning,
    required DateTime? timerEndTime,
    required Duration remaining,
    this.onTap,
  }) : _isRunning = isRunning,
       _timerEndTime = timerEndTime,
       _remaining = remaining;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _isRunning && _timerEndTime != null
            ? TimerCountdown(
                format: CountDownTimerFormat.hoursMinutesSeconds,
                enableDescriptions: false,
                spacerWidth: 0,
                colonsTextStyle: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                timeTextStyle: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                endTime: _timerEndTime!,
                onEnd: () {
                  // TODO: Tambahkan alarm notification
                },
              )
            : Text(
                // Saat pause, tampilkan sisa waktu manual
                // _currentMode == TimerMode.popular
                //     ? formatTimerDuration(_remainingPopular)
                //     : formatTimerDuration(_remainingCustom),
                formatTimerDuration(_remaining),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}
