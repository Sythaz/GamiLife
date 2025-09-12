import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class CarouselHome extends StatelessWidget {
  final CarouselSliderController controller;
  final int current;
  final Function(int, CarouselPageChangedReason) onPageChanged;
  final List<Widget> items;

  const CarouselHome({
    super.key,
    required this.controller,
    required this.current,
    required this.onPageChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            height: 140.0,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            onPageChanged: onPageChanged,
          ),
          items: items,
        ),
        items.asMap().length <= 1
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => controller.animateToPage(entry.key),
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      margin: const EdgeInsets.only(top: 10, right: 2, left: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: current == entry.key
                            ? AppColors.primary
                            : AppColors.gray2,
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
