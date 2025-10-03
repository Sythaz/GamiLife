import 'package:flutter/material.dart';
import 'package:gamilife/core/config/category_button_config.dart';
import 'package:gamilife/core/enums/enums_button_category.dart';
import 'package:gamilife/presentation/widgets/category_button.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/container_category_button.dart';

class AddProgressPage extends StatefulWidget {
  const AddProgressPage({super.key});

  @override
  State<AddProgressPage> createState() => _AddProgressPageState();
}

class _AddProgressPageState extends State<AddProgressPage> {
  AddProgressActivityCategory _currentCategory =
      AddProgressActivityCategory.activity;

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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerCategoryButton(
                currentCategory: _currentCategory,
                children: [
                  CustomCategoryButton(
                    label: 'Activity',
                    currentCategory: _currentCategory,
                    buttonCategory: AddProgressActivityCategory.activity,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      currentCategory: _currentCategory,
                      buttonCategory: AddProgressActivityCategory.activity,
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      currentCategory: _currentCategory,
                      buttonCategory: AddProgressActivityCategory.activity,
                    ),
                    onSelected: (activityValue) {
                      setState(() {
                        _currentCategory = activityValue;
                      });
                    },
                  ),
                  CustomCategoryButton(
                    label: 'Summary',
                    currentCategory: _currentCategory,
                    buttonCategory: AddProgressActivityCategory.summary,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      currentCategory: _currentCategory,
                      buttonCategory: AddProgressActivityCategory.summary,
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      currentCategory: _currentCategory,
                      buttonCategory: AddProgressActivityCategory.summary,
                    ),
                    onSelected: (activityValue) {
                      setState(() {
                        _currentCategory = activityValue;
                      });
                    },
                  ),
                  CustomCategoryButton(
                    label: 'To-do',
                    currentCategory: _currentCategory,
                    buttonCategory: AddProgressActivityCategory.todo,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      currentCategory: _currentCategory,
                      buttonCategory: AddProgressActivityCategory.todo,
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      currentCategory: _currentCategory,
                      buttonCategory: AddProgressActivityCategory.todo,
                    ),
                    onSelected: (activityValue) {
                      setState(() {
                        _currentCategory = activityValue;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                _currentCategory == AddProgressActivityCategory.activity
                    ? '- What have you done?'
                    : _currentCategory == AddProgressActivityCategory.summary
                    ? '- Let\'s share your reflections!'
                    : '- What are you planning to do?',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray3,
                ),
              ),
              TextFormField(
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
