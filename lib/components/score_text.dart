import 'package:flame/components.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/time_utils.dart';

class ScoreText extends TextComponent with HasGameRef<Training999> {

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topCenter;
    return super.onLoad();
  }

  @override
  void onMount() {
    position.translate(game.size.x * 3 / 4, 8);
    super.onMount();
  }

  @override
  void update(double dt) {
    text = '存活時間:${formatMilliseconds(game.surviveTime)}絕妙度:${gameRef.brilliantlyDodgedTheBullet}%';
    super.update(dt);
  }
}
