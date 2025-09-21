import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../helpers/timer_session.dart';

class TimerControllerWidget extends StatelessWidget {
  final TimerMode currentMode;

  final Duration remainingPopular;
  final Duration remainingCustom;

  final VoidCallback startTimer;
  final VoidCallback pauseTimer;
  final VoidCallback nextSession;
  final VoidCallback resetTimer;

  final bool isRunning;

  const TimerControllerWidget({
    super.key,
    required this.currentMode,
    required this.remainingPopular,
    required this.remainingCustom,
    required this.startTimer,
    required this.pauseTimer,
    required this.nextSession,
    required this.resetTimer,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: IconButton(
            onPressed: () {
              resetTimer();
            },
            icon: const Icon(
              Icons.restart_alt_rounded,
              size: 32,
              color: AppColors.white,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: IconButton(
            onPressed: () {
              // Ambil _remaining dari mode saat ini
              final currentRemaining = currentMode == TimerMode.popular
                  ? remainingPopular
                  : remainingCustom;

              // Jika memiliki waktu tersisa 00, maka return atau tidak melakukan apa-apa
              if (currentRemaining == Duration.zero) {
                return;
              }

              isRunning ? pauseTimer() : startTimer();
            },
            icon: isRunning
                ? const Icon(
                    Icons.pause_rounded,
                    size: 62,
                    color: AppColors.white,
                  )
                : const Icon(
                    Icons.play_arrow_rounded,
                    size: 62,
                    color: AppColors.white,
                  ),
          ),
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: IconButton(
            onPressed: () {
              nextSession();
            },
            icon: const Icon(
              Icons.skip_next_rounded,
              size: 32,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
