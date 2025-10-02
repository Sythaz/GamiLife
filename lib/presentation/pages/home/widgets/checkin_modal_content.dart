import 'package:flutter/material.dart';
import 'package:gamilife/presentation/pages/home/widgets/daily_checkin_xp.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';

class CheckInModalContent extends StatelessWidget {
  final int countCheckIn;
  const CheckInModalContent({super.key, required this.countCheckIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: AppColors.secondary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            iconSize: 32,
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.close,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Daily Check-in',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Anda akan mendapatkan ⚡ 100 XP dan 🔥 Willpower',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          countCheckIn > 7
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Wahh! Sudah 🔥 $countCheckIn Hari Beruntun!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DailyCheckInXP(isCheckIn: true, xp: 9998),
                DailyCheckInXP(xp: 100),
                DailyCheckInXP(xp: 100),
                DailyCheckInXP(xp: 100),
                DailyCheckInXP(xp: 100),
                DailyCheckInXP(xp: 100),
                DailyCheckInXP(xp: 100),
              ],
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Jaga konsistensi check-in harianmu!\nLewat satu hari, 15% XP totalmu akan berkurang.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: AppColors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(46),
                ),
              ),
              child: Text(
                'Check-in',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
