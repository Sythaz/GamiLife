import 'dart:ui';

import '../../presentation/pages/home/widgets/skill_point_card.dart';
import '../constants/colors.dart';

Map<String, Color> skillPointColor = {
  SkillName.INT.name: AppColors.purpleAccent,
  SkillName.Social.name: AppColors.secondary3,
  SkillName.VIT.name: AppColors.yellowAccent,
  SkillName.Willpower.name: AppColors.redAccent,
};

Color getSkillPointColor(String skillName) =>
    skillPointColor[skillName] ?? AppColors.white;

void addSkillPointColor(String skillName, Color color) {
  skillPointColor[skillName] = color;
}
