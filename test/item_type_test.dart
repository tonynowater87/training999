import 'package:flutter_test/flutter_test.dart';
import 'package:training999/util/item_type.dart';

void main() {
  test('every item has a positive cost and a unique shortcut', () {
    final keys = ItemType.values.map((type) => type.shortcutKey).toSet();
    expect(keys.length, ItemType.values.length);
    for (final type in ItemType.values) {
      expect(type.cost, greaterThan(0));
    }
  });

  test('timed items have a duration, instant items do not', () {
    expect(ItemType.slow.duration, greaterThan(0));
    expect(ItemType.shrink.duration, greaterThan(0));
    expect(ItemType.shield.duration, 0);
    expect(ItemType.bomb.duration, 0);
  });
}
