import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import 'widgets/date_picker_custom.dart';
import 'widgets/time_picker_custom.dart';

class AddTodoSection extends StatelessWidget {
  final TextEditingController _getCurrentCategoryController;
  final bool _isNotificationEnabled;
  final ValueChanged<bool> onNotificationChanged;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final TextEditingController? link;
  final ValueChanged<String> onLinkChanged;

  const AddTodoSection({
    super.key,
    required TextEditingController getCurrentCategoryController,
    required bool isNotificationEnabled,
    required this.onNotificationChanged,
    this.selectedDate,
    required this.onDateChanged,
    this.selectedTime,
    required this.onTimeChanged,
    this.link,
    required this.onLinkChanged,
  }) : _getCurrentCategoryController = getCurrentCategoryController,
       _isNotificationEnabled = isNotificationEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: InkWell(
                onTap: () {
                  onNotificationChanged(!_isNotificationEnabled);
                  // TODO: Tambahkan logic untuk notifikasi
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 26,
                              color: _isNotificationEnabled
                                  ? AppColors.primary
                                  : AppColors.gray2,
                            ),
                            Text(
                              'Notification',
                              style: TextStyle(
                                color: _isNotificationEnabled
                                    ? AppColors.primary
                                    : AppColors.gray2,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          child: CupertinoSwitch(
                            inactiveTrackColor: AppColors.gray0,
                            activeTrackColor: AppColors.primary,
                            inactiveThumbColor: AppColors.white,
                            value: _isNotificationEnabled,
                            onChanged: onNotificationChanged,
                          ),
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
                  onDateChanged(DateTime.now().add(const Duration(days: 1)));
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
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: TextField(
            controller: link,
            keyboardType: TextInputType.url,
            style: const TextStyle(color: AppColors.dark, fontSize: 12),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Link (optional)',
              hintStyle: const TextStyle(color: AppColors.gray2, fontSize: 12),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SvgPicture.asset(
                  'assets/icons/link_box.svg',
                  colorFilter: ColorFilter.mode(
                    (link?.text.isNotEmpty ?? false)
                        ? AppColors.primary
                        : AppColors.gray2,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 26,
                minHeight: 26,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: (link?.text.isNotEmpty ?? false)
                      ? AppColors.primary
                      : AppColors.gray2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
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
        const SizedBox(height: 16),
      ],
    );
  }
}
