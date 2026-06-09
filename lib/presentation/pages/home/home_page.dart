import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamilife/core/constants/colors.dart';
import 'package:gamilife/core/services/notification_service.dart';
import 'package:gamilife/core/providers/progress_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'widgets/banner_quest.dart';
import 'widgets/carousel_home.dart';
import 'widgets/heatmap_activities.dart';
import 'widgets/level_bar_container.dart';
import 'widgets/skill_point_card.dart';
import 'widgets/user_avatar.dart';
import 'widgets/user_head_info.dart';
import '../../widgets/timeline_recent_activities.dart';
import '../../../data/models/progress_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;
  final Map<DateTime, int> sampleData = {
    DateTime.now(): 1,
    DateTime.now().subtract(const Duration(days: 1)): 2,
    DateTime.now().subtract(const Duration(days: 2)): 4,
    DateTime.now().subtract(const Duration(days: 4)): 1,
  };

  int _calculateTotalSkillPoint(
    String skillName,
    List<ProgressModel> progressList,
  ) {
    int total = 0;
    for (var activity in progressList) {
      if (activity.skillsPoint != null &&
          activity.skillsPoint!.containsKey(skillName)) {
        total += activity.skillsPoint![skillName]!;
      }
    }
    return total;
  }

  int _calculateThisWeekSkillPoint(
    String skillName,
    List<ProgressModel> progressList,
  ) {
    int total = 0;

    // Cari tanggal paling baru dari seluruh data dummy
    DateTime? latestDate;
    for (var activity in progressList) {
      if (activity.date != null) {
        if (latestDate == null || activity.date!.isAfter(latestDate)) {
          latestDate = activity.date;
        }
      }
    }

    if (latestDate == null) return 0;

    // Menggunakan 7 hari terakhir dari tanggal terbaru tersebut
    final sevenDaysAgo = latestDate.subtract(const Duration(days: 7));

    for (var activity in progressList) {
      if (activity.date != null &&
          (activity.date!.isAfter(sevenDaysAgo) ||
              activity.date!.isAtSameMomentAs(sevenDaysAgo))) {
        if (activity.skillsPoint != null &&
            activity.skillsPoint!.containsKey(skillName)) {
          total += activity.skillsPoint![skillName]!;
        }
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    // Tampilkan permission dialog setelah build pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowNotificationPermission();
    });
  }

  // Check apakah sudah pernah request permission
  // Jika belum, tampilkan dialog yang bagus
  Future<void> _checkAndShowNotificationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAsked = prefs.getBool('notification_permission_asked') ?? false;

    if (!hasAsked && mounted) {
      _showNotificationPermissionDialog();
    }
  }

  // Dialog permission yang bagus
  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_active,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Aktifkan Notifikasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GamiLife ingin mengirimkan notifikasi untuk:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildPermissionFeature(
              Icons.task_alt,
              'Todo Reminders',
              'Ingatkan kamu untuk menyelesaikan todo',
            ),
            const SizedBox(height: 12),
            _buildPermissionFeature(
              Icons.timer,
              'Timer Alerts',
              'Notifikasi saat countdown selesai',
            ),
            const SizedBox(height: 12),
            _buildPermissionFeature(
              Icons.emoji_events,
              'Achievement Unlocked',
              'Rayakan pencapaian dan milestone',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // User decline
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('notification_permission_asked', true);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(
              'Nanti Saja',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // User accept - request permission
              final granted = await NotificationService().requestPermissions();

              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('notification_permission_asked', true);

              if (!context.mounted) return;

              Navigator.pop(context);

              // Show result
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    granted
                        ? '✅ Notifikasi berhasil diaktifkan!'
                        : '⚠️ Permission ditolak. Kamu bisa aktifkan di Settings.',
                  ),
                  backgroundColor: granted ? Colors.green : Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Aktifkan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk list feature di dialog
  Widget _buildPermissionFeature(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(allProgressStreamProvider);
    final List<ProgressModel> progressList = progressAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <ProgressModel>[],
    );

    // Ambil maksimal 15 data terbaru untuk Recent Activities
    final recentProgressList = progressList.take(15).toList();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      UserAvatar(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            UserHeadInfo(),
                            SizedBox(height: 6),
                            LevelBarContainer(
                              level: 79,
                              currentXP: 7681,
                              maxXP: 9999,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Skill Point',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkillPointCard(
                          skillName: SkillName.Social,
                          point: _calculateTotalSkillPoint(
                            'Social',
                            progressList,
                          ),
                          thisWeekAccumulationPoint:
                              _calculateThisWeekSkillPoint(
                                'Social',
                                progressList,
                              ),
                        ),
                        SkillPointCard(
                          skillName: SkillName.INT,
                          point: _calculateTotalSkillPoint('INT', progressList),
                          thisWeekAccumulationPoint:
                              _calculateThisWeekSkillPoint('INT', progressList),
                        ),
                        SkillPointCard(
                          skillName: SkillName.VIT,
                          point: _calculateTotalSkillPoint('VIT', progressList),
                          thisWeekAccumulationPoint:
                              _calculateThisWeekSkillPoint('VIT', progressList),
                        ),
                        SkillPointCard(
                          skillName: SkillName.Willpower,
                          point: _calculateTotalSkillPoint(
                            'Willpower',
                            progressList,
                          ),
                          thisWeekAccumulationPoint:
                              _calculateThisWeekSkillPoint(
                                'Willpower',
                                progressList,
                              ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // TODO: Add more Skill Point
                          },
                          child: SizedBox(
                            width: 88,
                            height: 95,
                            child: Card(
                              color: AppColors.white,
                              child: Icon(Icons.add, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.70,
              minChildSize: 0.70,
              maxChildSize: 0.94,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(46),
                      topRight: Radius.circular(46),
                    ),
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarouselHome(
                              controller: _controller,
                              current: _current,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              items: [
                                BannerQuest(),
                                CustomHeatmapContribution(
                                  contributionData: sampleData,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Recent Activities',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TimelineRecentActivities(
                              progressData: recentProgressList[index],
                            ),
                          );
                        }, childCount: recentProgressList.length),
                      ),
                      if (progressList.length > 15)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.pushNamed('progress');
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Lihat Lebih Banyak',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
