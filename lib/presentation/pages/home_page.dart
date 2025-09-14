import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamilife/core/constants/colors.dart';

import '../widget/banner_quest.dart';
import '../widget/carousel_home.dart';
import '../widget/heatmap_activities.dart';
import '../widget/timeline_recent_activities.dart';

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
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Home Page',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.97,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(46),
                    topRight: Radius.circular(46),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 6.5),
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 55,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: AppColors.gray2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.5),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Recent Activities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
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
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
