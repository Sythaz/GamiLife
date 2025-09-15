import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary3,
          ),
          width: 75,
          height: 75,
        ),
        Positioned(
          // top: -10,
          child: Image.asset(
            'assets/images/avatars/male-avatar-1.png',
            height: 97,
          ),
        ),
      ],
    );
  }
}
