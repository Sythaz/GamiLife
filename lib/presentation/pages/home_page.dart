import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamilife/core/constants/colors.dart';

import '../widget/banner_quest.dart';
import '../widget/carousel_home.dart';
import '../widget/heatmap_activities.dart';
import '../widget/level_bar_container.dart';
import '../widget/skill_point_card.dart';
import '../widget/timeline_recent_activities.dart';
import '../widget/user_avatar.dart';
import '../widget/user_head_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    Map<DateTime, int> sampleData = {
      // Juli 2025 (2 bulan lalu)
      DateTime(2025, 7, 1): 3,
      DateTime(2025, 7, 5): 7,
      DateTime(2025, 7, 10): 2,
      DateTime(2025, 7, 15): 5,
      DateTime(2025, 7, 20): 1,
      DateTime(2025, 7, 25): 4,
      DateTime(2025, 7, 30): 6,

      // Agustus 2025 (1 bulan lalu)
      DateTime(2025, 8, 2): 4,
      DateTime(2025, 8, 8): 2,
      DateTime(2025, 8, 12): 8,
      DateTime(2025, 8, 18): 3,
      DateTime(2025, 8, 22): 1,
      DateTime(2025, 8, 28): 5,

      // September 2025 (bulan sekarang - sesuaikan dengan tanggal sekarang)
      DateTime(2025, 9, 1): 2,
      DateTime(2025, 9, 5): 6,
      DateTime(2025, 9, 10): 3,
      DateTime(2025, 9, 14): 4, // Hari ini
    };

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
                          point: 99,
                          thisWeekAccumulationPoint: 20,
                        ),
                        SkillPointCard(
                          skillName: SkillName.INT,
                          point: 89,
                          thisWeekAccumulationPoint: 12,
                        ),
                        SkillPointCard(
                          skillName: SkillName.VIT,
                          point: 56,
                          thisWeekAccumulationPoint: 2,
                        ),
                        SkillPointCard(
                          skillName: SkillName.Willpower,
                          point: 89,
                          thisWeekAccumulationPoint: 0,
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
              initialChildSize: 0.73,
              minChildSize: 0.73,
              maxChildSize: 0.95,
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
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Column(
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
                          Text(
                            'Recent Activities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              TimelineRecentActivities(
                                time: '08:30',
                                date: '2025/09/28',
                                link:
                                    'https://www.youtube.com/watch?v=jq7zj8jJFso',
                                description:
                                    'Jogging selama 30 menit bersama teman-teman',
                                skillType: SkillType.activity,
                                skill: ['VIT', 'Social'],
                                point: '2',
                              ),
                              const SizedBox(height: 3),
                              TimelineRecentActivities(
                                time: '08:30',
                                date: '2025/09/28',
                                description:
                                    'Jogging selama 30 menit bersama teman-teman',
                                skillType: SkillType.summary,
                                point: '1',
                              ),
                              const SizedBox(height: 3),
                              TimelineRecentActivities(
                                time: '08:30',
                                date: '2025/09/28',
                                description:
                                    'Jogging selama 30 menit bersama teman-teman',
                                skillType: SkillType.todo,
                                point: '1',
                              ),
                            ],
                          ),
                        ],
                      ),
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
