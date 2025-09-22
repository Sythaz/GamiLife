import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class AddNewSessionButton extends StatelessWidget {
  const AddNewSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(top: 0),
      onPressed: () {},
      icon: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: const Icon(
          Icons.add,
          color: AppColors.primary,
          size: 32,
          // Agar icon lebih besar
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
