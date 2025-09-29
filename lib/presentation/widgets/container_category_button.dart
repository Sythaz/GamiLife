import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

// [T] disini memiliki arti bahwa tipe datanya belum ditentukan
// sehingga dapat menggunakan lebih dari 1 tipe data (enum) yang berbeda
class ContainerCategoryButton<T> extends StatelessWidget {
  final T currentCategory;
  final List<Widget> children;

  const ContainerCategoryButton({
    super.key,
    required this.currentCategory,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray0,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: Row(spacing: 3, children: children),
      ),
    );
  }
}
