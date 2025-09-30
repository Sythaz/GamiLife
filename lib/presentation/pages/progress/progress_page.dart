import 'package:flutter/material.dart';
import 'package:gamilife/core/config/category_button_config.dart';
import 'package:gamilife/core/constants/colors.dart';

import '../../../core/enums/enums_button_category.dart';
import '../../widgets/category_button.dart';
import '../../widgets/container_category_button.dart';
import '../../widgets/search_field.dart';
import 'widgets/date_filter_section.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDateFilterExpanded = false;

  ActivityCategory _currentActivityCategory = ActivityCategory.all;

  DateTime? _selectedDateFilter;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(searchController: _searchController),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            DateFilterSection(
              isDateFilterExpanded: _isDateFilterExpanded,
              onToggle: (bool isExpanded) {
                setState(() {
                  _isDateFilterExpanded = isExpanded;
                });
              },
              onDateSelect: (DateTime date) {
                setState(() {
                  if (_selectedDateFilter == date) {
                    // Jika date yang dipilih sama dengan yang sebelumnya,
                    // maka set selectedDateFilter menjadi null
                    _selectedDateFilter = null;
                    // Dan set isDateFilterExpanded menjadi false/menutup
                    _isDateFilterExpanded = false;
                  } else {
                    _selectedDateFilter = date;
                  }

                  print('Selected date: $_selectedDateFilter');
                  print('Date value: $date');
                });
              },
            ),
            Expanded(child: Center(child: Text('Konten di sini'))),
          ],
        ),
      ),
    );
  }
}
