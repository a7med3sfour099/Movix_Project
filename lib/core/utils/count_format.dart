/// Turns a raw TMDB total into a number that is believable on screen.
///
/// TMDB only lets an app page through 500 pages x 20 results = 10,000 items
/// per list, so anything above that is not really browsable. We cap at
/// [maxShown], round DOWN to the nearest 100 (never over-promise) and add
/// a "+" so it reads like "8,400+ items".
class CountFormat {
  CountFormat._();

  static const int maxShown = 10000;

  static String vault(int count) {
    if (count <= 0) return '0';
    final capped = count > maxShown ? maxShown : count;
    final rounded = capped >= 100 ? (capped ~/ 100) * 100 : capped;
    final text = _withCommas(rounded);
    return capped >= 100 ? '$text+' : text;
  }

  static String _withCommas(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
