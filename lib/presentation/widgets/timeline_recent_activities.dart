import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../core/constants/colors.dart';

enum SkillType { activity, summary, todo }

class TimelineRecentActivities extends StatelessWidget {
  static const todoIcon = '⚡';
  static const summaryIcon = '🔥';

  final String time, date, description;
  final SkillType skillType;
  final String? link;
  final List<String>? skill;
  final String point;

  const TimelineRecentActivities({
    required this.time,
    required this.date,
    required this.description,
    required this.skillType,
    required this.point,
    this.skill,
    this.link,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: true,
      indicatorStyle: IndicatorStyle(
        width: 24,
        height: 24,
        indicatorXY: 0,
        padding: const EdgeInsets.only(bottom: 3),
        indicator: Container(
          decoration: BoxDecoration(
            color: skillType == SkillType.todo
                ? AppColors.purpleAccent
                : skillType == SkillType.summary
                ? AppColors.yellowAccent
                : AppColors.secondary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            skillType == SkillType.todo
                ? todoIcon
                : skillType == SkillType.summary
                ? summaryIcon
                : '+$point',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      afterLineStyle: const LineStyle(color: AppColors.gray2, thickness: 1),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray2,
                    ),
                  ),
                  TextSpan(
                    text: ' - ',
                    style: TextStyle(color: AppColors.gray2),
                  ),
                  TextSpan(
                    text: date,
                    style: TextStyle(color: AppColors.gray2),
                  ),
                  TextSpan(
                    text: ' · ',
                    style: TextStyle(color: AppColors.gray2),
                  ),
                  TextSpan(
                    text: skillType == SkillType.todo
                        ? 'To-do'
                        : skillType == SkillType.summary
                        ? 'Summary'
                        : skill?.join(' · '),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: skillType == SkillType.todo
                          ? AppColors.purpleAccent
                          : skillType == SkillType.summary
                          ? AppColors.yellowAccent
                          : AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: AppColors.dark),
            ),
            const SizedBox(height: 6),
            link != null
                ? AnyLinkPreview(
                    // removeElevation: true,
                    link: link!,
                    displayDirection: UIDirection.uiDirectionHorizontal,
                    backgroundColor: AppColors.gray0,
                    borderRadius: 12,
                    errorTitle: 'Title Not Found',
                    errorBody:
                        'Oops, something went wrong to preview the link description',
                    errorWidget: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray0,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                      height: 135,
                      child: Center(child: Text('Failed to load preview')),
                    ),
                  )
                : Container(),
            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
