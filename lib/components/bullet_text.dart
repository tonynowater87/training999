import 'package:flame/components.dart';
import 'package:training999/training_999.dart';

class BulletText extends TextComponent with HasGameRef<Training999> {
  @override
  void onMount() {
    position.translate(16, 16);
    super.onMount();
  }

  @override
  void update(double dt) {
    text = 'Bullet: ${gameRef.bulletCount}';
    super.update(dt);
  }
}
