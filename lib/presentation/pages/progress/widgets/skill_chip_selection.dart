import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../home/widgets/skill_point_card.dart';

class SkillChipSelection extends StatelessWidget {
  final ValueChanged<List<String>> onSelected;
  final List<String?> selectedSkills;

  const SkillChipSelection({
    super.key,
    required this.selectedSkills,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          'Activity category:',
          style: TextStyle(
            color: selectedSkills.isNotEmpty
                ? AppColors.primary
                : AppColors.gray2,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var skill in SkillName.values)
                FilterChip(
                  // Agar margin antara FilterChip bisa diatur dengan Wrap
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  label: Text(
                    skill.name,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: selectedSkills.contains(skill.name),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.gray2,
                  onSelected: (bool selected) {
                    // Kita buat copy dari List selectedSkills
                    final updated = List<String>.from(selectedSkills);

                    if (selected) {
                      updated.add(skill.name);
                    } else {
                      updated.remove(skill.name);
                    }

                    // Karena menggunakan ValueChanged kita bisa mengirimkan data selectedSkills
                    // ke widget parent dan disana baru dilakukan [setState]
                    onSelected(updated);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
