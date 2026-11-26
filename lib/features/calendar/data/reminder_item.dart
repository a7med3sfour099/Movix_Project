class ReminderItem {
  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String time;
  final String posterUrl;
  final DateTime date;
  final bool isEnabled;

  const ReminderItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.posterUrl,
    required this.date,
    this.isEnabled = true,
  });

  ReminderItem copyWith({
    String? id,
    String? category,
    String? title,
    String? subtitle,
    String? time,
    String? posterUrl,
    DateTime? date,
    bool? isEnabled,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      posterUrl: posterUrl ?? this.posterUrl,
      date: date ?? this.date,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
