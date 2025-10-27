import 'dart:ui';

import '../constants/colors.dart';
import '../enums/enums_button_category.dart';

class ProgressCategoryButtonConfig<T extends Enum> {
  static Color background<T extends Enum>({
    required T currentCategory,
    required T buttonCategory,
  }) {
    if (buttonCategory != currentCategory) return AppColors.white;

    switch (buttonCategory) {
      case ActivityCategory.activity || AddProgressActivityCategory.activity:
        return AppColors.secondary;
      case ActivityCategory.summary || AddProgressActivityCategory.summary:
        return AppColors.yellowAccent;
      case ActivityCategory.todo || AddProgressActivityCategory.todo:
        return AppColors.purpleAccent;
      default:
        return AppColors.primary;
    }
  }

  static Color text<T extends Enum>({
    required T currentCategory,
    required T buttonCategory,
  }) {
    return buttonCategory == currentCategory
        ? AppColors.white
        : AppColors.gray3;
  }
}

// Memakai [<T extends Enum>] untuk dapat menggunakan 2 enum
// Karena config ini digunakan oleh lebih dari 1 button sehingga
// enum yang dipakai pasti lebih dari 1

class TimerCategoryButtonConfig<T extends Enum> {
  // [extends] sendiri memiliki arti bahwa tipe datanya adalah [Enum], tapi
  // belum ditentukan enum yang mana
  static Color background<T extends Enum>({
    // [T] disini memiliki arti bahwa tipe datanya belum ditentukan
    // sehingga dapat menggunakan lebih dari 1 tipe data (enum) yang berbeda
    required T currentCategory,
    required T buttonCategory,
  }) {
    return currentCategory == buttonCategory
        ? AppColors.white
        : AppColors.gray0;
  }

  static Color text<T extends Enum>({
    required T currentCategory,
    required T buttonCategory,
  }) {
    return currentCategory == buttonCategory
        ? AppColors.primary
        : AppColors.gray2;
  }
}