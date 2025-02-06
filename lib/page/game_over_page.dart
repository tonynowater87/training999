
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:training999/components/rounded_button.dart';
import 'package:training999/training_999.dart';

class GameOverPage extends Component with HasGameReference<Training999> {

  late final RoundedButton _playAgainButton;

  @override
  Future<void> onLoad() async {
    _playAgainButton = RoundedButton(
      text: 'Play Again',
      action: () {
        game.menuSelectAudioPool.start();
        game.reset();
        game.router.pop();
        game.router.pushNamed("menu");
      },
      color: const Color(0xffadde6c),
      borderColor: const Color(0xffedffab),
    );

    add(_playAgainButton);
  }

  @override
  void onMount() {
    game.addBulletCountText();
    super.onMount();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _playAgainButton.position = Vector2(size.x / 2, size.y - size.y / 4);
  }
}