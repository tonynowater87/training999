import 'package:flutter_test/flutter_test.dart';
import 'package:training999/util/time_utils.dart';

void main() {
  test('formats milliseconds as seconds with three decimals', () {
    expect(formatMilliseconds(0), '0.000');
    expect(formatMilliseconds(45), '0.045');
    expect(formatMilliseconds(12045), '12.045');
    expect(formatMilliseconds(61000), '61.000');
  });
}
