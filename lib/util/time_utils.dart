/// Formats milliseconds as seconds with three decimals, e.g. 12045 -> "12.045".
String formatMilliseconds(int milliseconds) {
  final seconds = (milliseconds ~/ 1000).toString();
  final remainingMilliseconds =
      (milliseconds % 1000).toString().padLeft(3, '0');
  return '$seconds.$remainingMilliseconds';
}
