import 'package:flutter/material.dart';
import 'package:gamilife/core/constants/colors.dart';
import 'package:gamilife/presentation/pages/home/home_page.dart';
import 'package:gamilife/presentation/pages/timer/timer_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

  late final List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = [
      const HomePage(),
      const Placeholder(), // Timer
      const TimerPage(), // Progress
      const Placeholder(), // Profile
    ];
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _widgets),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 5,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: AppColors.white,
          size: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        // height: 70,
        padding: EdgeInsets.zero,
        color: AppColors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _navButton(0, Icons.home, 'Home'),
                  _navButton(1, Icons.trending_up, 'Progress'),
                ],
              ),
            ),
            SizedBox(width: 72),
            Expanded(
              child: Row(
                children: [
                  _navButton(2, Icons.timer_outlined, 'Timer'),
                  _navButton(3, Icons.person_outline, 'Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(int indexTab, IconData icon, String label) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _changeTab(indexTab),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: _selectedIndex == indexTab
                    ? AppColors.primary
                    : AppColors.gray2,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: _selectedIndex == indexTab
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedIndex == indexTab
                      ? AppColors.primary
                      : AppColors.gray2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
