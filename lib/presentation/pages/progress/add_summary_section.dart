import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/colors.dart';

class AddSummarySection extends StatelessWidget {
  final TextEditingController _getCurrentCategoryController;
  final bool isWeekend;
  final TextEditingController? link;
  final ValueChanged<String> onLinkChanged;

  const AddSummarySection({
    super.key,
    required TextEditingController getCurrentCategoryController,
    required this.isWeekend,
    this.link,
    required this.onLinkChanged,
  }) : _getCurrentCategoryController = getCurrentCategoryController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _getCurrentCategoryController,
          cursorColor: AppColors.primary,
          minLines: 5,
          maxLines: null,
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray0, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: TextField(
            controller: link,
            onChanged: (value) => onLinkChanged(value),
            keyboardType: TextInputType.url,
            style: TextStyle(color: AppColors.dark, fontSize: 12),
            decoration: InputDecoration(
              isDense: true, // Agar TextField lebih kecil
              hint: Text(
                'Link (optional)',
                style: TextStyle(color: AppColors.gray2, fontSize: 12),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SvgPicture.asset(
                  'assets/icons/link_box.svg',
                  colorFilter: ColorFilter.mode(
                    link?.text.isNotEmpty == true
                        ? AppColors.primary
                        : AppColors.gray2,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 26,
                minHeight: 26,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: link != null ? AppColors.primary : AppColors.gray2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  // TODO: Saat focus warna gray2 tapi saat sudah disii jadi primary
                  color: link?.text.isNotEmpty == true
                      ? AppColors.primary
                      : AppColors.gray2,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Announcement: ',
                style: TextStyle(
                  color: AppColors.yellowAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    'The weekly summary will be open on weekends, so stay tuned!',
                style: TextStyle(
                  color: AppColors.gray3,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        isWeekend
            ? Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // TODO: Tambahkan logic untuk memilih tangal hari ini
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Save as weekly summary!',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
