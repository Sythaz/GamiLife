import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

Future<DateTime?> showDatePickerCustom(BuildContext context) {
  return showDatePicker(
    context: context,
    firstDate: DateTime(2000),
    initialDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(color: AppColors.primary),
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onSurface: AppColors.gray2,
          ),
        ),
        child: child!,
      );
    },
  );
}
