import 'dart:ui';

import '../constants/colors.dart';
import '../enums/enums_button_category.dart';

class ProgressCategoryButtonConfig {
  static Color background({
    required ActivityCategory currentCategory,
    required ActivityCategory buttonCategory,
  }) {
    if (buttonCategory != currentCategory) return AppColors.white;

    switch (buttonCategory) {
      case ActivityCategory.all:
        return AppColors.primary;
      case ActivityCategory.activity:
        return AppColors.secondary;
      case ActivityCategory.summary:
        return AppColors.yellowAccent;
      case ActivityCategory.todo:
        return AppColors.purpleAccent;
    }
  }

  static Color text({
    required ActivityCategory currentCategory,
    required ActivityCategory buttonCategory,
  }) {
    return buttonCategory == currentCategory
        ? AppColors.white
        : AppColors.gray3;
  }
}

class TimerCategoryButtonConfig {
  static Color background({
    required TimerCategory currentCategory,
    required TimerCategory buttonCategory,
  }) {
    return currentCategory == buttonCategory
        ? AppColors.white
        : AppColors.gray0;
  }

  static Color text({
    required TimerCategory currentCategory,
    required TimerCategory buttonCategory,
  }) {
    return currentCategory == buttonCategory
        ? AppColors.primary
        : AppColors.gray2;
  }
}
