import 'package:flutter/material.dart';
import 'package:gamilife/core/constants/colors.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Progress Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(searchController: _searchController),
            Expanded(child: Center(child: Text('Konten di sini'))),
          ],
        ),
      ),
    );
  }
}

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
                hintText: 'Search..',
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
