import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/colors.dart';

/// Widget untuk menampilkan progress bar XP dengan animasi dan efek shimmer.
class AnimatedXPBar extends StatefulWidget {
  final double currentXP; // Nilai XP saat ini
  final double maxXP; // Nilai XP maksimum
  final double? height;

  const AnimatedXPBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    this.height,
  });

  @override
  State<AnimatedXPBar> createState() => _AnimatedXPBarState();
}

class _AnimatedXPBarState extends State<AnimatedXPBar> {
  double _progress = 0.0; // Persentase progress (0.0 - 1.0)
  bool _isShimmering = false; // Status apakah shimmer sedang aktif

  @override
  void initState() {
    super.initState();
    _updateProgress(); // Hitung progress awal

    // Aktifkan shimmer selama 2 detik saat pertama kali ditampilkan
    _isShimmering = true;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isShimmering = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedXPBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Jika nilai XP berubah, update progress dan aktifkan shimmer kembali
    if (oldWidget.currentXP != widget.currentXP ||
        oldWidget.maxXP != widget.maxXP) {
      _updateProgress();

      // Aktifkan shimmer kembali
      setState(() {
        _isShimmering = true;
      });

      // Tutup shimmer setelah 2 detik
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isShimmering = false;
          });
        }
      });
    }
  }

  // Menghitung progress berdasarkan currentXP dan maxXP
  void _updateProgress() {
    setState(() {
      _progress = (widget.currentXP / (widget.maxXP == 0 ? 1 : widget.maxXP))
          .clamp(
            0.0,
            1.0,
          ); // Hindari pembagian dengan nol dan batasi antara 0-1
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 8, // Tinggi progress bar
      child: Stack(
        children: [
          // Latar belakang progress bar
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Progress bar yang dianimasikan
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                // Saat progress kurang dari 85%, durasi 600ms, saat progress lebih dari 85% durasi 800ms
                duration: Duration(milliseconds: _progress > 0.85 ? 800 : 400),
                curve: Curves.easeInOut,
                width:
                    constraints.maxWidth * _progress, // Lebar sesuai progress
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),

          // Efek shimmer saat progress berubah
          // Langkah-langkah untuk menampilkan efek shimmer saat progress berubah
          if (_isShimmering)
            LayoutBuilder(
              builder: (context, constraints) {
                return Shimmer.fromColors(
                  // Durasi efek shimmer selama 1 detik
                  period: const Duration(seconds: 1),
                  // Warna dasar untuk efek shimmer
                  baseColor: AppColors.secondary.withAlpha((255 * 0.5).toInt()),
                  // Warna highlight untuk efek shimmer
                  highlightColor: AppColors.gray0.withAlpha(
                    (255 * 0.5).toInt(),
                  ),
                  child: SizedBox(
                    // Lebar efek shimmer sesuai dengan progress
                    width: constraints.maxWidth * _progress,
                    height: widget.height ?? 8,
                    child: ColoredBox(color: AppColors.secondary),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
