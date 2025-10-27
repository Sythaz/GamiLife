import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import 'widgets/date_picker_custom.dart';
import 'widgets/skill_chip_selection.dart';
import 'widgets/skill_point_slider.dart';

import 'widgets/time_picker_custom.dart';

class AddActivitySection extends StatelessWidget {
  final TextEditingController _getCurrentCategoryController;
  final List<String> selectedSkills;
  final Map<String, int> selectedSkillsPoint;
  final ValueChanged<List<String>> onChipSelected;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final TextEditingController? link;
  final ValueChanged<String> onLinkChanged;
  final void Function(String skillName, int value) onChangedSkillSlider;

  const AddActivitySection({
    super.key,
    required TextEditingController getCurrentCategoryController,
    required this.selectedSkills,
    required this.selectedSkillsPoint,
    required this.onChipSelected,
    required this.onChangedSkillSlider,
    this.selectedDate,
    required this.onDateChanged,
    this.selectedTime,
    required this.onTimeChanged,
    this.link,
    required this.onLinkChanged,
  }) : _getCurrentCategoryController = getCurrentCategoryController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _getCurrentCategoryController,
          cursorColor: AppColors.primary,
          minLines: 5,
          maxLines: null,
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray0, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () async {
                  final pickedDate = await showDatePickerCustom(context);

                  if (pickedDate != null) onDateChanged(pickedDate);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedDate != null
                          ? AppColors.primary
                          : AppColors.gray2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.event_available_outlined,
                          size: 26,
                          color: selectedDate != null
                              ? AppColors.primary
                              : AppColors.gray2,
                        ),
                        Text(
                          selectedDate != null
                              ? '${DateFormat('EEEE').format(selectedDate!)}, ${DateFormat('d MMM yyyy').format(selectedDate!)}'
                              : 'Select Date',
                          style: TextStyle(
                            color: selectedDate != null
                                ? AppColors.dark
                                : AppColors.gray2,
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
                  onDateChanged(DateTime.now());
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
                      'Today',
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
                onTap: () async {
                  final TimeOfDay? timePicked = await showTimePickerCustom(
                    context,
                  );

                  if (timePicked != null) onTimeChanged(timePicked);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedTime != null
                          ? AppColors.primary
                          : AppColors.gray2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 26,
                          color: selectedTime != null
                              ? AppColors.primary
                              : AppColors.gray2,
                        ),
                        Text(
                          selectedTime != null
                              ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                              : 'Select Time',
                          style: TextStyle(
                            color: selectedTime != null
                                ? AppColors.dark
                                : AppColors.gray2,
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
                  onTimeChanged(TimeOfDay.now());
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
        SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: TextField(
            controller: link,
            onChanged: (value) => onLinkChanged(value),
            keyboardType: TextInputType.url,
            style: TextStyle(color: AppColors.dark, fontSize: 12),
            decoration: InputDecoration(
              isDense: true, // Agar TextField lebih kecil
              hint: Text(
                'Link (optional)',
                style: TextStyle(color: AppColors.gray2, fontSize: 12),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SvgPicture.asset(
                  'assets/icons/link_box.svg',
                  colorFilter: ColorFilter.mode(
                    link?.text.isNotEmpty == true
                        ? AppColors.primary
                        : AppColors.gray2,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 26,
                minHeight: 26,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: link != null ? AppColors.primary : AppColors.gray2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  // TODO: Saat focus warna gray2 tapi saat sudah disii jadi primary
                  color: link?.text.isNotEmpty == true
                      ? AppColors.primary
                      : AppColors.gray2,
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
        SkillChipSelection(
          selectedSkills: selectedSkills,
          onSelected: onChipSelected,
        ),
        SizedBox(height: 16),
        Column(
          spacing: 16,
          children: selectedSkillsPoint.keys
              .map(
                (skillName) => SkillPointSlider(
                  skillName: skillName,
                  selectedSkillsPoint: selectedSkillsPoint,
                  onChanged: (double value) {
                    onChangedSkillSlider(skillName, value.toInt());
                  },
                ),
              )
              .toList(),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
