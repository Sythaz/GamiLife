import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class DailyCheckInXP extends StatelessWidget {
  final bool isCheckIn;
  final int xp;

  const DailyCheckInXP({super.key, this.isCheckIn = false, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isCheckIn ? AppColors.primary : AppColors.gray1,
          ),
          child: Center(
            child: Text(
              'XP',
              style: TextStyle(
                color: isCheckIn ? AppColors.white : AppColors.gray2,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          '$xp XP',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: isCheckIn ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
