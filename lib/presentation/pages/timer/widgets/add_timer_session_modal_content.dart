import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

enum TimerCategoryMode { focus, rest }

class AddTimerModalContent extends StatefulWidget {
  const AddTimerModalContent({super.key});

  @override
  State<AddTimerModalContent> createState() => _AddTimerModalContentState();
}

class _AddTimerModalContentState extends State<AddTimerModalContent> {
  TimerCategoryMode _currentTimerCategory = TimerCategoryMode.focus;
  final TextEditingController _timerLabelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          iconSize: 32,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Add Timer',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
            child: Text(
              'Choose category',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.gray0,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // Set [_currentTimerCategory] menjadi TimerCategoryMode.focus
                          _currentTimerCategory = TimerCategoryMode.focus;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _currentTimerCategory == TimerCategoryMode.focus
                              ? AppColors.white
                              : AppColors.gray0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Focus',
                            style: TextStyle(
                              color:
                                  _currentTimerCategory ==
                                      TimerCategoryMode.focus
                                  ? AppColors.primary
                                  : AppColors.gray2,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // Set [_currentTimerCategory] menjadi TimerCategoryMode.rest
                          _currentTimerCategory = TimerCategoryMode.rest;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _currentTimerCategory == TimerCategoryMode.rest
                              ? AppColors.white
                              : AppColors.gray0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Rest',
                            style: TextStyle(
                              color:
                                  _currentTimerCategory ==
                                      TimerCategoryMode.rest
                                  ? AppColors.primary
                                  : AppColors.gray2,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
            child: Text(
              'Add label',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _timerLabelController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write some label here...',
                hintStyle: TextStyle(
                  color: AppColors.gray3,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              style: TextStyle(color: AppColors.gray2, fontSize: 12),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
              top: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: AppColors.white,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      //
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      //
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
