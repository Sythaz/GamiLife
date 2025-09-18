import 'package:flutter/material.dart';
import 'package:gamilife/presentation/pages/home/widgets/checkin_modal_content.dart';

import '../../../../core/constants/colors.dart';
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
                  isDismissible: false,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return CheckInModalContent(countCheckIn: 8);
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
