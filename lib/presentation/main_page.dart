import 'package:flutter/material.dart';
import 'package:gamilife/core/constants/colors.dart';
import 'package:gamilife/presentation/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = [
      const HomePage(),
      const Placeholder(), // Explore
      const Placeholder(), // Notifications
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
        color: AppColors.white,
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 30,
                    onPressed: () => _changeTab(0),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    iconSize: 30,
                    onPressed: () => _changeTab(1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 100),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    iconSize: 30,
                    onPressed: () => _changeTab(2),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 30,
                    onPressed: () => _changeTab(3),
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
