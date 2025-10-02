import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';

class AddProgressPage extends StatefulWidget {
  const AddProgressPage({super.key});

  @override
  State<AddProgressPage> createState() => _AddProgressPageState();
}

class _AddProgressPageState extends State<AddProgressPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 2,
          shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text(
            'Add Progress',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  // TODO: Tambahkan logic untuk menyimpan progress
                  context.pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: const Center(child: Text('Add Progress Page')),
      ),
    );
  }
}
