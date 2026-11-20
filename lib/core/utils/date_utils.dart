const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "1995-12-27" -> "Dec 27, 1995". Empty if the date is missing/invalid.
String formatDate(String? date) {
  final d = DateTime.tryParse(date ?? '');
  if (d == null) return '';
  return '${_months[d.month - 1]} ${d.day}, ${d.year}';
}

/// Age today, or age at death when [deathday] is given.
int? ageFrom(String? birthday, {String? deathday}) {
  final born = DateTime.tryParse(birthday ?? '');
  if (born == null) return null;
  final end = DateTime.tryParse(deathday ?? '') ?? DateTime.now();
  var age = end.year - born.year;
  if (end.month < born.month || (end.month == born.month && end.day < born.day)) {
    age--;
  }
  return age;
}

/// 420000 -> "420k", 1200000 -> "1.2M".
String compactCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).round()}k';
  return '$n';
}
