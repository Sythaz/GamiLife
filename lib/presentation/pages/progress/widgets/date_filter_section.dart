import 'package:calendar_day_slot_navigator/calendar_day_slot_navigator.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class DateFilterSection extends StatelessWidget {
  final Function(bool) onToggle;
  final Function(DateTime) onDateSelect;
  final DateTime? selectedDate;

  const DateFilterSection({
    super.key,
    required bool isDateFilterExpanded,
    required this.onToggle,
    required this.onDateSelect,
    required this.selectedDate,
  }) : _isDateFilterExpanded = isDateFilterExpanded;

  final bool _isDateFilterExpanded;

  @override
  Widget build(BuildContext context) {
    bool isFilter = selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onToggle(!_isDateFilterExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isFilter ? Icons.filter_alt : Icons.filter_alt_off,
                      size: 20,
                      color: isFilter ? AppColors.primary : AppColors.gray2,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Filter by Date',
                      style: TextStyle(
                        color: isFilter ? AppColors.primary : AppColors.gray2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => {
                if (isFilter)
                  {onDateSelect(selectedDate!)}
                else
                  _isDateFilterExpanded == false,
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      Icons.restart_alt_rounded,
                      size: 20,
                      color: isFilter ? AppColors.primary : AppColors.gray2,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: isFilter ? AppColors.primary : AppColors.gray2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isDateFilterExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                CalendarDaySlotNavigator(
                  activeColor: AppColors.primary,
                  slotLength: 5,
                  dayBoxHeightAspectRatio: 6,
                  monthYearTabBorderRadius: 10,
                  dayBoxBorderRadius: 12,
                  dayDisplayMode: DayDisplayMode.inDateBox,
                  onDateSelect: onDateSelect,
                ),
                const SizedBox(height: 10),
                Divider(
                  radius: BorderRadius.circular(50),
                  color: AppColors.gray2,
                  thickness: 0.4,
                ),
              ],
            ),
            // Menggunakan SizedBox.shrink() dan bukan Container() maupun SizedBox()
            // karena SizedBox.shrink() paling aman dan ringan untuk "tidak menampilkan apa-apa"
            // sedangkan Container() dan SizedBox() masih berisiko menempati ruang kosong
            secondChild: SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
