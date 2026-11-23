import 'package:flutter_test/flutter_test.dart';
import 'package:training999/util/bullet_level.dart';

void main() {
  test('harder bullets are faster and bigger', () {
    expect(
        BulletLevel.easy.getSpeed(), lessThan(BulletLevel.middle.getSpeed()));
    expect(
        BulletLevel.middle.getSpeed(), lessThan(BulletLevel.hard.getSpeed()));
    expect(
        BulletLevel.easy.getRadius(), lessThan(BulletLevel.hard.getRadius()));
  });

  test('every level spawns periodically', () {
    for (final level in BulletLevel.values) {
      expect(level.getPeriod(), greaterThan(0));
    }
  });
}
