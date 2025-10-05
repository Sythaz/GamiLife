import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../core/config/skill_point_config.dart';
import '../../../../core/constants/colors.dart';

class SkillPointSlider extends StatelessWidget {
  final String skillName;
  final Map<String, int> selectedSkillsPoint;
  final ValueChanged<double> onChanged;

  const SkillPointSlider({
    super.key,
    required this.skillName,
    required this.selectedSkillsPoint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: getSkillPointColor(skillName),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$skillName Skill Point',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(+${selectedSkillsPoint[skillName]})',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SfSlider(
          value: selectedSkillsPoint[skillName] ?? 1,
          min: 1,
          max: 10,
          interval: 1,
          activeColor: getSkillPointColor(skillName),
          showTicks: true,
          showLabels: true,
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
