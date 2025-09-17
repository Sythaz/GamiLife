import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import 'starfield_painter.dart';

// Terdapat MediaQuery dan onPressed sehingga lebih baik tidak dijadikan const saat dipanggil
class BannerQuest extends StatelessWidget {
  const BannerQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.topLeft,
          begin: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.secondary3],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: StarfieldPainter())),
          Positioned(
            left: 16,
            top: 16,
            child: Text(
              'The Quest Starts Today',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 46,
            child: Text(
              'Level up your life, one mission at a time',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      color: AppColors.secondary,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.close, color: AppColors.white),
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
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(115, 40),
                backgroundColor: AppColors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(46),
                ),
              ),
              child: Text(
                'Check In',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
