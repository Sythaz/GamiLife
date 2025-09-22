import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../helpers/format_duration.dart';
import '../helpers/timer_session.dart';

class SessionContainer extends StatelessWidget {
  final int index;
  final VoidCallback changeSession;

  final TimerMode currentMode;

  final int currentSessionIndexPopular;
  final int currentSessionIndexCustom;

  final List<TimerSession> popularSession;
  final List<TimerSession> customSession;

  const SessionContainer({
    super.key,
    required this.index,
    required this.changeSession,
    required this.currentMode,
    required this.currentSessionIndexPopular,
    required this.currentSessionIndexCustom,
    required this.popularSession,
    required this.customSession,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: Tambahkan fungsi edit session
      // onTap: ,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icon session
                  Container(
                    height: double.infinity,
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentMode == TimerMode.popular
                          ? currentSessionIndexPopular == index
                                ? AppColors.primary
                                : AppColors.gray0
                          : currentSessionIndexCustom == index
                          ? AppColors.primary
                          : AppColors.gray0,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      currentMode == TimerMode.popular
                          ? popularSession[index].icon
                          : customSession.isNotEmpty
                          ? customSession[index].icon
                          : Icons.error_outline,
                      size: 32,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Durasi dan label session
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // Format durasi sesi 00:00 dari function format
                        formatSessionDuration(
                          currentMode == TimerMode.popular
                              ? popularSession[index].duration
                              : customSession[index].duration,
                        ),
                        style: TextStyle(
                          color: AppColors.gray3,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentMode == TimerMode.popular
                            ? popularSession[index].label
                            : customSession[index].label,
                        style: TextStyle(
                          color: AppColors.gray3,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Icon play atau changeSession (restart)
              InkWell(
                onTap: changeSession,
                // Background icon
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentMode == TimerMode.popular
                        ? currentSessionIndexPopular == index ||
                                  currentSessionIndexPopular == index - 1
                              ? AppColors.primary
                              : AppColors.gray0
                        : currentSessionIndexCustom == index ||
                              currentSessionIndexCustom == index - 1
                        ? AppColors.primary
                        : AppColors.gray0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Icon Button
                  child: currentMode == TimerMode.popular
                      ? currentSessionIndexPopular == index ||
                                currentSessionIndexPopular == index + 1
                            ? Icon(
                                Icons.restart_alt_rounded,
                                color: AppColors.white,
                              )
                            : Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                              )
                      : currentSessionIndexCustom == index
                      ? Icon(Icons.restart_alt_rounded, color: AppColors.white)
                      : Icon(Icons.play_arrow_rounded, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
