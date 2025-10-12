import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamilife/core/config/category_button_config.dart';
import 'package:gamilife/core/enums/enums_button_category.dart';
import 'package:gamilife/presentation/widgets/custom_category_button.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/container_category_button.dart';
import 'add_activity_section.dart';

class AddProgressPage extends StatefulWidget {
  const AddProgressPage({super.key});

  @override
  State<AddProgressPage> createState() => _AddProgressPageState();
}

class _AddProgressPageState extends State<AddProgressPage> {
  AddProgressActivityCategory _currentCategory =
      AddProgressActivityCategory.activity;

  final _activityCategoryController = TextEditingController();
  final _summaryCategoryController = TextEditingController();
  final _todoCategoryController = TextEditingController();

  TextEditingController get _getCurrentCategoryController {
    switch (_currentCategory) {
      case AddProgressActivityCategory.activity:
        return _activityCategoryController;
      case AddProgressActivityCategory.summary:
        return _summaryCategoryController;
      case AddProgressActivityCategory.todo:
        return _todoCategoryController;
    }
  }

  List<String> selectedSkills = [];
  Map<String, int> selectedSkillsPoint = {};

  final isWeekend =
      DateTime.now().weekday == DateTime.saturday ||
      DateTime.now().weekday == DateTime.sunday;

  bool _isNotificationEnabled = false;

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
                style: const TextStyle(fontSize: 12, color: AppColors.gray3),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child:
                      _currentCategory == AddProgressActivityCategory.activity
                      ? AddActivitySection(
                          getCurrentCategoryController:
                              _getCurrentCategoryController,
                          selectedSkills: selectedSkills,
                          selectedSkillsPoint: selectedSkillsPoint,
                          onChipSelected: (List<String> newSelectedSkillsList) {
                            setState(() {
                              // Hapus yang tidak dipilih menggunakan removeWhere dari map
                              selectedSkillsPoint.removeWhere(
                                // Jika skill tidak ada di newSelectedSkillsList maka true dan hapus
                                (skill, _) =>
                                    !newSelectedSkillsList.contains(skill),
                              );

                              // Tambahkan yang baru dipilih (dengan nilai default 1)
                              for (final skill in newSelectedSkillsList) {
                                // Jika skill belum ada di map (putIfAbsent)
                                // maka tambahkan nama skill itu dengan nilai default 1
                                selectedSkillsPoint.putIfAbsent(skill, () => 1);
                              }

                              // Update selectedSkills dengan newSelectedSkillsList
                              // yang telah dikirim dari SkillChipSelection onSelected
                              selectedSkills = newSelectedSkillsList;
                            });
                          },
                          onChangedSkillSlider: (String skillName, int value) {
                            setState(() {
                              selectedSkillsPoint[skillName] = value;
                            });
                          },
                        )
                      : _currentCategory == AddProgressActivityCategory.summary
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _getCurrentCategoryController,
                              cursorColor: AppColors.primary,
                              minLines: 5,
                              maxLines: null,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.gray0,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.url,
                                style: TextStyle(
                                  color: AppColors.dark,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  isDense: true, // Agar TextField lebih kecil
                                  hint: Text(
                                    'Link (optional)',
                                    style: TextStyle(
                                      color: AppColors.gray2,
                                      fontSize: 12,
                                    ),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/link_box.svg',
                                      colorFilter: ColorFilter.mode(
                                        // TODO: Saat controller link tidak ada isi, maka jadikan warna gray2 tapi saat sudah disii jadi primary
                                        AppColors.gray2,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 26,
                                    minHeight: 26,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.gray2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      // TODO: Saat focus warna gray2 tapi saat sudah disii jadi primary
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Announcement: ',
                                    style: TextStyle(
                                      color: AppColors.yellowAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'The weekly summary will be open on weekends, so stay tuned!',
                                    style: TextStyle(
                                      color: AppColors.gray3,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isWeekend
                                ? Column(
                                    children: [
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                // TODO: Tambahkan logic untuk memilih tangal hari ini
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: double.infinity,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'Save as weekly summary!',
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _getCurrentCategoryController,
                              cursorColor: AppColors.primary,
                              minLines: 5,
                              maxLines: null,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.gray0,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Tambahkan logic untuk memilih tanggal
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _isNotificationEnabled
                                              ? AppColors.primary
                                              : AppColors.gray2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .notifications_none_rounded,
                                                  size: 26,
                                                  color: _isNotificationEnabled
                                                      ? AppColors.primary
                                                      : AppColors.gray2,
                                                ),
                                                Text(
                                                  'Notification',
                                                  style: TextStyle(
                                                    color:
                                                        _isNotificationEnabled
                                                        ? AppColors.primary
                                                        : AppColors.gray2,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            CupertinoSwitch(
                                              inactiveTrackColor:
                                                  AppColors.gray0,
                                              activeTrackColor:
                                                  AppColors.primary,
                                              inactiveThumbColor:
                                                  AppColors.white,
                                              value: _isNotificationEnabled,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isNotificationEnabled =
                                                      value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Tambahkan logic untuk memilih tanggal
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            Icon(
                                              Icons.event_available_outlined,
                                              size: 26,
                                              color: AppColors.primary,
                                            ),
                                            Text(
                                              'Rabu, 24 September 2025',
                                              style: TextStyle(
                                                color: AppColors.dark,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Tambahkan logic untuk memilih tangal hari ini
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Tomorrow',
                                          style: TextStyle(
                                            color: AppColors.white,
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
                            const SizedBox(height: 16),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Tambahkan logic untuk memilih waktu
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.gray2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            Icon(
                                              Icons.schedule,
                                              size: 26,
                                              color: AppColors.gray2,
                                            ),
                                            Text(
                                              'Time',
                                              style: TextStyle(
                                                color: AppColors.gray2,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Tambahkan logic untuk memilih waktu saat ini
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Now',
                                          style: TextStyle(
                                            color: AppColors.white,
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
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.url,
                                style: TextStyle(
                                  color: AppColors.dark,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  isDense: true, // Agar TextField lebih kecil
                                  hint: Text(
                                    'Link (optional)',
                                    style: TextStyle(
                                      color: AppColors.gray2,
                                      fontSize: 12,
                                    ),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/link_box.svg',
                                      colorFilter: ColorFilter.mode(
                                        // TODO: Saat controller link tidak ada isi, maka jadikan warna gray2 tapi saat sudah disii jadi primary
                                        AppColors.gray2,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 26,
                                    minHeight: 26,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.gray2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      // TODO: Saat focus warna gray2 tapi saat sudah disii jadi primary
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
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
