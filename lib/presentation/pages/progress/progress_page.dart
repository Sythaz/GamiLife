import 'package:flutter/material.dart';
import 'package:gamilife/core/config/category_button_config.dart';
import 'package:gamilife/core/constants/colors.dart';

import '../../../core/enums/enums_button_category.dart';
import '../../widgets/category_button.dart';
import '../../widgets/container_category_button.dart';
import '../../widgets/search_field.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final TextEditingController _searchController = TextEditingController();

  ActivityCategory _currentActivityCategory = ActivityCategory.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Progress Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(searchController: _searchController),
            SizedBox(height: 16),
            ContainerCategoryButton(
              currentCategory: _currentActivityCategory,
              children: [
                CustomCategoryButton(
                  label: 'All',
                  currentCategory: _currentActivityCategory,
                  buttonCategory: ActivityCategory.all,
                  buttonColorLogic: ProgressCategoryButtonConfig.background(
                    buttonCategory: ActivityCategory.all,
                    currentCategory: _currentActivityCategory,
                  ),
                  textColorLogic: ProgressCategoryButtonConfig.text(
                    buttonCategory: ActivityCategory.all,
                    currentCategory: _currentActivityCategory,
                  ),
                  onSelected: (value) {
                    // Disini value bernilai sama dengan yang dikirimkan ke buttonCategory
                    setState(() {
                      _currentActivityCategory = value;
                    });
                  },
                ),
                CustomCategoryButton(
                  label: 'Activity',
                  currentCategory: _currentActivityCategory,
                  buttonCategory: ActivityCategory.activity,
                  buttonColorLogic: ProgressCategoryButtonConfig.background(
                    buttonCategory: ActivityCategory.activity,
                    currentCategory: _currentActivityCategory,
                  ),
                  textColorLogic: ProgressCategoryButtonConfig.text(
                    buttonCategory: ActivityCategory.activity,
                    currentCategory: _currentActivityCategory,
                  ),
                  onSelected: (value) {
                    // Disini value bernilai sama dengan yang dikirimkan ke buttonCategory
                    setState(() {
                      _currentActivityCategory = value;
                    });
                  },
                ),
                CustomCategoryButton(
                  label: 'Summary',
                  currentCategory: _currentActivityCategory,
                  buttonCategory: ActivityCategory.summary,
                  buttonColorLogic: ProgressCategoryButtonConfig.background(
                    buttonCategory: ActivityCategory.summary,
                    currentCategory: _currentActivityCategory,
                  ),
                  textColorLogic: ProgressCategoryButtonConfig.text(
                    buttonCategory: ActivityCategory.summary,
                    currentCategory: _currentActivityCategory,
                  ),
                  onSelected: (value) {
                    // Disini value bernilai sama dengan yang dikirimkan ke buttonCategory
                    setState(() {
                      _currentActivityCategory = value;
                    });
                  },
                ),
                CustomCategoryButton(
                  label: 'Todo',
                  currentCategory: _currentActivityCategory,
                  buttonCategory: ActivityCategory.todo,
                  buttonColorLogic: ProgressCategoryButtonConfig.background(
                    buttonCategory: ActivityCategory.todo,
                    currentCategory: _currentActivityCategory,
                  ),
                  textColorLogic: ProgressCategoryButtonConfig.text(
                    buttonCategory: ActivityCategory.todo,
                    currentCategory: _currentActivityCategory,
                  ),
                  onSelected: (value) {
                    // Disini value bernilai sama dengan yang dikirimkan ke buttonCategory
                    setState(() {
                      _currentActivityCategory = value;
                    });
                  },
                ),
              ],
            ),
            Expanded(child: Center(child: Text('Konten di sini'))),
          ],
        ),
      ),
    );
  }
}
