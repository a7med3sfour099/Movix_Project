String formatRating(double rating) {
  if (rating == 0) return 'NR';
  return rating.toStringAsFixed(1);
}
