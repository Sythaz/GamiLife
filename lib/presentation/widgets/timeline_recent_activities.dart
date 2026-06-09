import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:gamilife/data/models/progress_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../core/constants/colors.dart';

enum SkillType { activity, summary, todo }

class TimelineRecentActivities extends StatelessWidget {
  static const todoIcon = '⚡';
  static const summaryIcon = '🔥';

  final ProgressModel progressData;

  const TimelineRecentActivities({required this.progressData, super.key});

  @override
  Widget build(BuildContext context) {
    // Derive skill type from progress type
    SkillType skillType;
    switch (progressData.type) {
      case ProgressType.activity:
        skillType = SkillType.activity;
        break;
      case ProgressType.summary:
        skillType = SkillType.summary;
        break;
      case ProgressType.todo:
        skillType = SkillType.todo;
        break;
    }

    // Calculate total point
    String totalPoint = '0';
    if (progressData.skillsPoint != null &&
        progressData.skillsPoint!.isNotEmpty) {
      final sum = progressData.skillsPoint!.values.reduce((a, b) => a + b);
      totalPoint = sum.toString();
    }

    // Format date
    String formattedDate = '';
    if (progressData.date != null) {
      formattedDate =
          '${progressData.date!.year}/${progressData.date!.month.toString().padLeft(2, '0')}/${progressData.date!.day.toString().padLeft(2, '0')}';
    }

    final skillLabel = skillType == SkillType.todo
        ? 'To-do'
        : skillType == SkillType.summary &&
              progressData.isSummaryWeekly == false
        ? 'Daily Summary'
        : skillType == SkillType.summary && progressData.isSummaryWeekly == true
        ? 'Weekly Summary'
        : (progressData.skills == null || progressData.skills!.isEmpty)
        ? 'Activity'
        : progressData.skills!.join(' · ');

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
                : '+$totalPoint',
            style: const TextStyle(
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
                    text: progressData.time ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray2,
                    ),
                  ),
                  TextSpan(
                    text: ' - ',
                    style: TextStyle(color: AppColors.gray2),
                  ),
                  TextSpan(
                    text: formattedDate,
                    style: const TextStyle(color: AppColors.gray2),
                  ),
                  TextSpan(
                    text: ' · ',
                    style: const TextStyle(color: AppColors.gray2),
                  ),
                  TextSpan(
                    text: skillLabel,
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
              progressData.description,
              style: const TextStyle(fontSize: 12, color: AppColors.dark),
            ),
            const SizedBox(height: 6),
            _buildLinkPreview(progressData.link),
            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }

  // Validate URL format
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Build link preview with proper error handling
  Widget _buildLinkPreview(String? link) {
    // No link provided
    if (link == null || link.isEmpty) {
      return const SizedBox.shrink();
    }

    // Invalid URL format - show warning
    if (!_isValidUrl(link)) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invalid URL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    link,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Valid URL - show preview
    return AnyLinkPreview(
      link: link,
      displayDirection: UIDirection.uiDirectionHorizontal,
      backgroundColor: AppColors.gray0,
      borderRadius: 12,
      cache: const Duration(hours: 1), // Cache untuk performance
      // Jangan pakai errorImage (bisa gagal load juga)
      // errorTitle & errorBody tidak dipakai kalau ada errorWidget

      // Loading state
      placeholderWidget: Container(
        decoration: BoxDecoration(
          color: AppColors.gray0,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Loading link preview...',
                style: TextStyle(fontSize: 12, color: AppColors.gray2),
              ),
            ),
          ],
        ),
      ),

      // Error state - tampilan yang bagus tanpa network image
      errorWidget: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade50,
              Colors.red.shade100.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200, width: 1.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.link_off_rounded,
                color: Colors.red.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Link Preview Unavailable',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Could not load preview for this link',
                    style: TextStyle(fontSize: 11, color: Colors.red.shade700),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      link,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red.shade800,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
