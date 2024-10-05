import 'package:flame/components.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/time_utils.dart';

class BulletText extends TextComponent with HasGameRef<Training999> {
  int lastTime = 0;
  int playTime = 0;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topCenter;
    return super.onLoad();
  }

  @override
  void onMount() {
    position.translate(game.size.x / 2, 8);
    super.onMount();
  }

  @override
  void update(double dt) {
    if (gameRef.isGameOver) {
      lastTime = 0;
      playTime = 0;
      return;
    }

    var dateTime = DateTime.now();
    if (lastTime == 0) {
      lastTime = dateTime.millisecondsSinceEpoch;
    }
    var now = dateTime.millisecondsSinceEpoch;
    playTime = now - lastTime;

    text = '${formatMilliseconds(playTime)} Level: ${gameRef.defaultLevel}';
    // TODO display bullet count
    // text = 'Bullet: ${gameRef.bulletCount}';
    super.update(dt);
  }
}
