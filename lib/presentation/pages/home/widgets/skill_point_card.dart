import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

// ignore: constant_identifier_names
enum SkillName { Social, INT, VIT, Willpower }

class SkillPointCard extends StatelessWidget {
  final SkillName skillName;
  final int point;
  final int thisWeekAccumulationPoint;

  const SkillPointCard({
    super.key,
    required this.skillName,
    required this.point,
    required this.thisWeekAccumulationPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: skillName == SkillName.Social
          ? AppColors.secondary3
          : skillName == SkillName.INT
          ? AppColors.purpleAccent
          : skillName == SkillName.VIT
          ? AppColors.yellowAccent
          : AppColors.redAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          children: [
            Text(
              skillName.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              point.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: skillName == SkillName.Social
                    ? AppColors.secondary
                    : skillName == SkillName.INT
                    ? AppColors.purpleAccent2
                    : skillName == SkillName.VIT
                    ? AppColors.yellowAccent2
                    : AppColors.redAccent2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 1.5,
                      top: 3.5,
                      bottom: 3.5,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: thisWeekAccumulationPoint > 0
                            ? AppColors.primary
                            : AppColors.yellowAccent,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        thisWeekAccumulationPoint > 19
                            ? '19+'
                            : '+${thisWeekAccumulationPoint.toString()}',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 1.5,
                      right: 3,
                      top: 3.5,
                      bottom: 3.5,
                    ),
                    child: Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
