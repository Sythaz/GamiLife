// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamilife/core/config/category_button_config.dart';
import 'package:gamilife/core/enums/enums_button_category.dart';
import 'package:gamilife/presentation/pages/progress/add_todo_section.dart';
import 'package:gamilife/presentation/pages/progress/controllers/add_progress_controller.dart';
import 'package:gamilife/presentation/widgets/custom_category_button.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/container_category_button.dart';
import 'add_activity_section.dart';
import 'add_summary_section.dart';

class AddProgressPage extends ConsumerStatefulWidget {
  const AddProgressPage({super.key});

  @override
  ConsumerState<AddProgressPage> createState() => _AddProgressPageState();
}

class _AddProgressPageState extends ConsumerState<AddProgressPage> {
  // Text controllers untuk UI input
  final _activityCategoryController = TextEditingController();
  final _summaryCategoryController = TextEditingController();
  final _todoCategoryController = TextEditingController();

  final _activityLinkController = TextEditingController();
  final _summaryLinkController = TextEditingController();
  final _todoLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Setup listeners untuk sync text controllers dengan state
    _activityCategoryController.addListener(() {
      ref
          .read(addProgressControllerProvider.notifier)
          .setActivityDescription(_activityCategoryController.text);
    });

    _summaryCategoryController.addListener(() {
      ref
          .read(addProgressControllerProvider.notifier)
          .setSummaryDescription(_summaryCategoryController.text);
    });

    _todoCategoryController.addListener(() {
      ref
          .read(addProgressControllerProvider.notifier)
          .setTodoDescription(_todoCategoryController.text);
    });

    _activityLinkController.addListener(() {
      ref
          .read(addProgressControllerProvider.notifier)
          .setActivityLink(_activityLinkController.text);
    });

    _summaryLinkController.addListener(() {
      ref
          .read(addProgressControllerProvider.notifier)
          .setSummaryLink(_summaryLinkController.text);
    });

    _todoLinkController.addListener(() {
      ref
          .read(addProgressControllerProvider.notifier)
          .setTodoLink(_todoLinkController.text);
    });
  }

  @override
  void dispose() {
    _activityCategoryController.dispose();
    _summaryCategoryController.dispose();
    _todoCategoryController.dispose();
    _activityLinkController.dispose();
    _summaryLinkController.dispose();
    _todoLinkController.dispose();
    super.dispose();
  }

  TextEditingController get _getCurrentCategoryController {
    final category = ref.read(addProgressControllerProvider).currentCategory;
    switch (category) {
      case AddProgressActivityCategory.activity:
        return _activityCategoryController;
      case AddProgressActivityCategory.summary:
        return _summaryCategoryController;
      case AddProgressActivityCategory.todo:
        return _todoCategoryController;
    }
  }

  TextEditingController get _getCurrentLinkController {
    final category = ref.read(addProgressControllerProvider).currentCategory;
    switch (category) {
      case AddProgressActivityCategory.activity:
        return _activityLinkController;
      case AddProgressActivityCategory.summary:
        return _summaryLinkController;
      case AddProgressActivityCategory.todo:
        return _todoLinkController;
    }
  }

  Future<void> _handleSave() async {
    final controller = ref.read(addProgressControllerProvider.notifier);
    final errorMessage = await controller.saveProgress();

    if (!mounted) return;

    if (errorMessage != null) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.orange),
      );
    } else {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProgressControllerProvider);
    final controller = ref.read(addProgressControllerProvider.notifier);

    final isWeekend =
        DateTime.now().weekday == DateTime.saturday ||
        DateTime.now().weekday == DateTime.sunday;

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
            onPressed: () => context.pop(),
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
                onTap: state.isSaving ? null : _handleSave,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: state.isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : const Text(
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
                currentCategory: state.currentCategory,
                children: [
                  CustomCategoryButton(
                    label: 'Activity',
                    currentCategory: state.currentCategory,
                    buttonCategory: AddProgressActivityCategory.activity,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      currentCategory: state.currentCategory,
                      buttonCategory: AddProgressActivityCategory.activity,
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      currentCategory: state.currentCategory,
                      buttonCategory: AddProgressActivityCategory.activity,
                    ),
                    onSelected: (category) => controller.setCategory(category),
                  ),
                  CustomCategoryButton(
                    label: 'Summary',
                    currentCategory: state.currentCategory,
                    buttonCategory: AddProgressActivityCategory.summary,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      currentCategory: state.currentCategory,
                      buttonCategory: AddProgressActivityCategory.summary,
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      currentCategory: state.currentCategory,
                      buttonCategory: AddProgressActivityCategory.summary,
                    ),
                    onSelected: (category) => controller.setCategory(category),
                  ),
                  CustomCategoryButton(
                    label: 'To-do',
                    currentCategory: state.currentCategory,
                    buttonCategory: AddProgressActivityCategory.todo,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      currentCategory: state.currentCategory,
                      buttonCategory: AddProgressActivityCategory.todo,
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      currentCategory: state.currentCategory,
                      buttonCategory: AddProgressActivityCategory.todo,
                    ),
                    onSelected: (category) => controller.setCategory(category),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                state.currentCategory == AddProgressActivityCategory.activity
                    ? '- What have you done?'
                    : state.currentCategory ==
                          AddProgressActivityCategory.summary
                    ? '- Let\'s share your reflections!'
                    : '- What are you planning to do?',
                style: const TextStyle(fontSize: 12, color: AppColors.gray3),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child:
                      state.currentCategory ==
                          AddProgressActivityCategory.activity
                      ? AddActivitySection(
                          getCurrentCategoryController:
                              _getCurrentCategoryController,
                          selectedSkills: state.activitySkills,
                          selectedSkillsPoint: state.activitySkillsPoint,
                          onChipSelected: (skills) {
                            // Update skills point map
                            final newSkillsPoint = Map<String, int>.from(
                              state.activitySkillsPoint,
                            );

                            // Remove unselected skills
                            newSkillsPoint.removeWhere(
                              (skill, _) => !skills.contains(skill),
                            );

                            // Add new skills with default value 1
                            for (final skill in skills) {
                              newSkillsPoint.putIfAbsent(skill, () => 1);
                            }

                            controller.setActivitySkills(
                              skills,
                              newSkillsPoint,
                            );
                          },
                          selectedDate: state.activityDate,
                          onDateChanged: (date) =>
                              controller.setActivityDate(date),
                          selectedTime: state.activityTime,
                          onTimeChanged: (time) =>
                              controller.setActivityTime(time),
                          onChangedSkillSlider: (skillName, value) {
                            final updatedSkillsPoint = Map<String, int>.from(
                              state.activitySkillsPoint,
                            );
                            updatedSkillsPoint[skillName] = value;
                            controller.setActivitySkills(
                              state.activitySkills,
                              updatedSkillsPoint,
                            );
                          },
                          link: _getCurrentLinkController,
                          onLinkChanged: (_) {}, // Handled by listener
                        )
                      : state.currentCategory ==
                            AddProgressActivityCategory.summary
                      ? AddSummarySection(
                          getCurrentCategoryController:
                              _getCurrentCategoryController,
                          isWeekend: isWeekend,
                          link: _getCurrentLinkController,
                          onTapWeekly: (value) {
                            controller.setSummaryWeekly(value);
                            if (value) {
                              // Auto save ketika toggle weekly
                              _handleSave();
                            }
                          },
                          onLinkChanged: (_) {}, // Handled by listener
                        )
                      : AddTodoSection(
                          getCurrentCategoryController:
                              _getCurrentCategoryController,
                          selectedDate: state.todoDate,
                          onDateChanged: (date) => controller.setTodoDate(date),
                          selectedTime: state.todoTime,
                          onTimeChanged: (time) => controller.setTodoTime(time),
                          isNotificationEnabled: state.isNotificationEnabled,
                          onNotificationChanged: (value) =>
                              controller.setNotificationEnabled(value),
                          link: _getCurrentLinkController,
                          onLinkChanged: (_) {}, // Handled by listener
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
