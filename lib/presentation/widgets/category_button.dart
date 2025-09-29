import 'package:flutter/material.dart';

import '../../core/enums/enums_button_category.dart';

class CustomCategoryButton extends StatelessWidget {
  final String label;
  final ActivityCategory currentCategory;
  final ActivityCategory buttonCategory;
  final Color buttonColorLogic;
  final Color textColorLogic;
  final ValueChanged<ActivityCategory> onSelected;

  const CustomCategoryButton({
    super.key,
    required this.label,
    required this.currentCategory,
    required this.buttonCategory,
    required this.buttonColorLogic,
    required this.textColorLogic,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onSelected(buttonCategory);
        },
        child: Container(
          decoration: BoxDecoration(
            color: buttonColorLogic,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColorLogic,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
