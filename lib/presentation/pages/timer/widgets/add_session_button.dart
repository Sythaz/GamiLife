import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import 'add_timer_session_modal_content.dart';

class AddSessionButton extends StatelessWidget {
  const AddSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(top: 0),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0B6C4C), AppColors.primary],
                      stops: [0.0, 0.6], // Distribusi gradient
                    ),
                  ),
                  child: AddTimerModalContent(),
                ),
              ),
            );
          },
        );
      },
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
