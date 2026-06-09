enum ProgressType { activity, summary, todo }

class ProgressModel {
  int id;

  ProgressType type;

  bool? isSummaryWeekly;

  String description;

  String? link;

  // List untuk menyimpan skill
  List<String>? skills;

  // Map untuk menyimpan skill dan pointnya
  // Contoh: {"VIT": 2, "Social": 1}
  Map<String, int>? skillsPoint;

  // Helper untuk konversi Map ke List untuk disimpan di ISAR
  List<String>? get skillsPointList {
    if (skillsPoint == null) return null;
    return skillsPoint!.entries.map((e) => '${e.key}:${e.value}').toList();
  }

  set skillsPointList(List<String>? value) {
    if (value == null) {
      skillsPoint = null;
      return;
    }
    skillsPoint = Map.fromEntries(
      value.map((e) {
        final parts = e.split(':');
        return MapEntry(parts[0], int.parse(parts[1]));
      }),
    );
  }

  DateTime? date;

  String? time; // Format: "HH:mm"

  // For Todo type
  bool? isNotificationEnabled;

  DateTime createdAt = DateTime.now();

  ProgressModel({
    this.id = 0,
    this.type = ProgressType.activity,
    this.isSummaryWeekly = false,
    this.description = '',
    this.link,
    this.skills,
    this.skillsPoint,
    this.date,
    this.time,
    this.isNotificationEnabled,
  });
}
