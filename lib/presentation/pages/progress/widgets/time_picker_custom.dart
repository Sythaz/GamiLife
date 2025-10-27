import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

Future<TimeOfDay?> showTimePickerCustom(BuildContext context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: AppColors.gray2,
            ),
          ),
          child: child!,
        ),
      );
    },
  );
}
