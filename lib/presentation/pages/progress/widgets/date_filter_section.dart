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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => onToggle(!_isDateFilterExpanded),
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.only(right: 10, bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selectedDate != null
                          ? Icons.filter_alt
                          : Icons.filter_alt_off,
                      size: 20,
                      color: selectedDate != null
                          ? AppColors.primary
                          : AppColors.gray2,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Filter by Date',
                      style: TextStyle(color: AppColors.gray2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isDateFilterExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: CalendarDaySlotNavigator(
              activeColor: AppColors.primary,
              slotLength: 5,
              dayBoxHeightAspectRatio: 6,
              monthYearTabBorderRadius: 10,
              dayBoxBorderRadius: 12,
              dayDisplayMode: DayDisplayMode.inDateBox,
              onDateSelect: onDateSelect,
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
