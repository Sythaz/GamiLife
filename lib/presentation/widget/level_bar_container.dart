import 'package:flutter/material.dart';
import 'package:gamilife/presentation/widget/animated_xp_bar.dart';

import '../../core/constants/colors.dart';

class LevelBarContainer extends StatelessWidget {
  final int level; // Nilai level
  final double currentXP; // Nilai XP saat ini
  final double maxXP; // Nilai XP maksimum

  const LevelBarContainer({
    super.key,
    required this.level,
    required this.currentXP,
    required this.maxXP,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return Container(
          width: maxWidth,
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.primary2,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level $level',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'XP ',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: currentXP.toInt().toString(),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '/${maxXP.toInt().toString()}',
                            style: TextStyle(
                              color: AppColors.primary3,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedXPBar(currentXP: currentXP, maxXP: maxXP),
              ],
            ),
          ),
        );
      },
    );
  }
}
