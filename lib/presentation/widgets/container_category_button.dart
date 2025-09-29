import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/enums/enums_button_category.dart';

class ContainerCategoryButton extends StatelessWidget {
  final ActivityCategory currentActivityCategory;
  final List<Widget> children;

  const ContainerCategoryButton({
    super.key,
    required this.currentActivityCategory,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray0,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: Row(spacing: 3, children: children),
      ),
    );
  }
}
