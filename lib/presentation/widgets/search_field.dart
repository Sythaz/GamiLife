import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.gray2),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search, color: AppColors.gray2, size: 24),
          ),
          Container(width: 1.2, height: 22, color: AppColors.gray2),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.gray3, fontSize: 16),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search...',
                hintStyle: TextStyle(color: AppColors.gray2, fontSize: 16),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
