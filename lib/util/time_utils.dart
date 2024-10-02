String formatMilliseconds(int milliseconds) {
  final seconds = (milliseconds ~/ 1000).toString();
  final remainingMilliseconds = (milliseconds % 1000).toString().padLeft(3, '0');
  return '$seconds:$remainingMilliseconds';
}