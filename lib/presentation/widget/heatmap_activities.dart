import 'package:flutter/material.dart';
import 'package:gamilife/core/constants/colors.dart';

class CustomHeatmapContribution extends StatelessWidget {
  final Map<DateTime, int> contributionData;

  CustomHeatmapContribution({Key? key, required this.contributionData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current month and 2 previous months
    DateTime now = DateTime.now();
    List<DateTime> months = [
      DateTime(now.year, now.month - 2, 1), // 2 bulan lalu
      DateTime(now.year, now.month - 1, 1), // 1 bulan lalu
      DateTime(now.year, now.month, 1), // Bulan sekarang
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _buildSeparatedHeatmapGrid(months),
    );
  }

  // Header bulan
  Widget _buildMonthHeaders(List<DateTime> months) {
    return Row(
      children: months.map((month) {
        int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
        int weeksInMonth =
            ((daysInMonth + DateTime(month.year, month.month, 1).weekday - 1) /
                    7)
                .ceil();
        double monthWidth =
            (weeksInMonth * 16.0) +
            ((weeksInMonth - 1) * 3.0); // width per week + spacing

        return Container(
          margin: month.month != months.first.month
              ? const EdgeInsets.only(left: 24)
              : null, // Jarak antar bulan kecuali bulan pertama
          width: monthWidth,
          child: Text(
            _getMonthName(month.month),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Grid heatmap terpisah per bulan
  Widget _buildSeparatedHeatmapGrid(List<DateTime> months) {
    return Row(
      children: [
        _buildDayLabels(),
        SizedBox(width: 8),
        Column(
          children: [
            _buildMonthHeaders(months),
            SizedBox(height: 8),
            Row(
              children: [
                ...months.map((month) {
                  return Container(
                    margin: month.month != months.last.month
                        ? const EdgeInsets.only(right: 16)
                        : null, // Jarak antar bulan kecuali bulan terakhir
                    child: _buildMonthGrid(month),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Label hari (Mon, Wed, Fri)
  Widget _buildDayLabels() {
    // Hari yang ditampilkan
    List<String> dayLabels = ['', 'Mon', '', 'Wed', '', 'Fri', ''];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dayLabels.isNotEmpty) SizedBox(height: 27),
        ...dayLabels
            .map(
              (label) => Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            .toList(),
      ],
      // dayLabels
      //     .map(
      //       (label) => Text(
      //         label,
      //         style: TextStyle(
      //           fontSize: 12,
      //           color: AppColors.dark,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     )
      //     .toList(),
    );
  }

  // Grid untuk satu bulan tertentu
  Widget _buildMonthGrid(DateTime month) {
    List<List<DateTime?>> weeks = _generateMonthWeeksGrid(month);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeks
          .map(
            (week) => Container(
              margin: EdgeInsets.only(right: 5),
              child: Column(
                children: week
                    .map(
                      (date) => Container(
                        // Besar kotak per hari
                        width: 13,
                        height: 13,
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: date != null
                              ? _getContributionColor(date)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }

  // Generate grid mingguan untuk satu bulan saja
  List<List<DateTime?>> _generateMonthWeeksGrid(DateTime month) {
    List<List<DateTime?>> weeks = [];

    // Tanggal pertama dan terakhir bulan
    DateTime firstDay = DateTime(month.year, month.month, 1);
    DateTime lastDay = DateTime(month.year, month.month + 1, 0);

    // Mulai dari minggu yang berisi tanggal 1
    DateTime startOfWeek = firstDay.subtract(
      Duration(days: firstDay.weekday % 7),
    );

    DateTime currentWeekStart = startOfWeek;

    while (currentWeekStart.month <= month.month ||
        currentWeekStart.isBefore(lastDay)) {
      List<DateTime?> week = [];

      for (int i = 0; i < 7; i++) {
        DateTime dayInWeek = currentWeekStart.add(Duration(days: i));

        // Hanya tampilkan jika dalam bulan yang sama
        if (dayInWeek.month == month.month && dayInWeek.year == month.year) {
          week.add(dayInWeek);
        } else {
          week.add(null);
        }
      }

      // Hanya tambahkan week jika ada hari dalam bulan tersebut
      if (week.any((day) => day != null)) {
        weeks.add(week);
      }

      currentWeekStart = currentWeekStart.add(Duration(days: 7));

      // Stop jika sudah melewati bulan
      if (currentWeekStart.month > month.month &&
          currentWeekStart.year >= month.year) {
        break;
      }
    }

    return weeks;
  }

  // Warna berdasarkan intensitas contribution
  Color _getContributionColor(DateTime date) {
    int intensity =
        contributionData[DateTime(date.year, date.month, date.day)] ?? 0;

    if (intensity == 0) {
      return AppColors.gray0; // Abu-abu terang untuk hari tanpa aktivitas
    } else if (intensity <= 2) {
      return AppColors.primary2; // Hijau terang
    } else if (intensity <= 4) {
      return AppColors.primary; // Hijau sedang
    } else {
      return AppColors.primary3; // Hijau sangat gelap
    }
  }

  // Convert nomor bulan ke nama
  String _getMonthName(int month) {
    // const months = [
    //   'Jan',
    //   'Feb',
    //   'Mar',
    //   'Apr',
    //   'May',
    //   'Jun',
    //   'Jul',
    //   'Aug',
    //   'Sep',
    //   'Oct',
    //   'Nov',
    //   'Dec',
    // ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

// Widget untuk menampilkan legend
// class HeatmapLegend extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Less', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//         SizedBox(width: 8),

//         // Legend squares
//         Row(
//           children: [
//             _buildLegendSquare(Color(0xFFEBEDF0)),
//             SizedBox(width: 3),
//             _buildLegendSquare(Color(0xFFC6E48B)),
//             SizedBox(width: 3),
//             _buildLegendSquare(Color(0xFF7BC96F)),
//             SizedBox(width: 3),
//             _buildLegendSquare(Color(0xFF239A3B)),
//             SizedBox(width: 3),
//             _buildLegendSquare(Color(0xFF196127)),
//           ],
//         ),

//         SizedBox(width: 8),
//         Text('More', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//       ],
//     );
//   }

//   Widget _buildLegendSquare(Color color) {
//     return Container(
//       width: 10,
//       height: 10,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }
// }
