import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamilife/core/config/category_button_config.dart';
import 'package:gamilife/core/constants/colors.dart';
import 'package:gamilife/core/providers/progress_provider.dart';
import 'package:gamilife/presentation/widgets/timeline_recent_activities.dart';

import '../../../core/enums/enums_button_category.dart';
import '../../widgets/custom_category_button.dart';
import '../../widgets/container_category_button.dart';
import '../../widgets/search_field.dart';
import 'widgets/date_filter_section.dart';
import 'widgets/draggable_scroll_up_button.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isDateFilterExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(
                searchController: _searchController,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
              SizedBox(height: 10),
              ContainerCategoryButton(
                currentCategory: ref.watch(activityCategoryProvider),
                children: [
                  CustomCategoryButton(
                    label: 'All',
                    currentCategory: ref.watch(activityCategoryProvider),
                    buttonCategory: ActivityCategory.all,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      buttonCategory: ActivityCategory.all,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      buttonCategory: ActivityCategory.all,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    onSelected: (value) {
                      ref.read(activityCategoryProvider.notifier).state = value;
                    },
                  ),
                  CustomCategoryButton(
                    label: 'Activity',
                    currentCategory: ref.watch(activityCategoryProvider),
                    buttonCategory: ActivityCategory.activity,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      buttonCategory: ActivityCategory.activity,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      buttonCategory: ActivityCategory.activity,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    onSelected: (value) {
                      ref.read(activityCategoryProvider.notifier).state = value;
                    },
                  ),
                  CustomCategoryButton(
                    label: 'Summary',
                    currentCategory: ref.watch(activityCategoryProvider),
                    buttonCategory: ActivityCategory.summary,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      buttonCategory: ActivityCategory.summary,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      buttonCategory: ActivityCategory.summary,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    onSelected: (value) {
                      ref.read(activityCategoryProvider.notifier).state = value;
                    },
                  ),
                  CustomCategoryButton(
                    label: 'Todo',
                    currentCategory: ref.watch(activityCategoryProvider),
                    buttonCategory: ActivityCategory.todo,
                    buttonColorLogic: ProgressCategoryButtonConfig.background(
                      buttonCategory: ActivityCategory.todo,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    textColorLogic: ProgressCategoryButtonConfig.text(
                      buttonCategory: ActivityCategory.todo,
                      currentCategory: ref.watch(activityCategoryProvider),
                    ),
                    onSelected: (value) {
                      ref.read(activityCategoryProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              DateFilterSection(
                selectedDate: ref.watch(dateFilterProvider),
                isDateFilterExpanded: _isDateFilterExpanded,
                onToggle: (bool isExpanded) {
                  setState(() {
                    _isDateFilterExpanded = isExpanded;
                  });
                },
                onDateSelect: (DateTime date) {
                  final currentDate = ref.read(dateFilterProvider);
                  if (currentDate == date) {
                    ref.read(dateFilterProvider.notifier).state = null;
                    setState(() {
                      _isDateFilterExpanded = false;
                    });
                  } else {
                    ref.read(dateFilterProvider.notifier).state = date;
                  }
                },
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double maxX = constraints.maxWidth;
                    final double maxY = constraints.maxHeight;

                    return Stack(
                      children: [
                        ref
                            .watch(allProgressStreamProvider)
                            .when(
                              data: (_) {
                                final progressList = ref.watch(
                                  filteredProgressProvider,
                                );

                                if (progressList.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No progress data found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.gray3,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: progressList.length,
                                  itemBuilder: (context, index) {
                                    final progress = progressList[index];

                                    return TimelineRecentActivities(
                                      progressData: progress,
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                              error: (error, stack) => Center(
                                child: Text(
                                  'Failed to load progress: $error',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                        AnimatedBuilder(
                          animation: _scrollController,
                          builder: (context, child) {
                            return DraggableScrollUpButton(
                              scrollController: _scrollController,
                              maxX: maxX,
                              maxY: maxY,
                              isVisible:
                                  _scrollController.hasClients &&
                                  _scrollController.position.pixels > 0,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
