import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:training999/training_999.dart';

class SplashScreenPage extends Component with HasGameReference<Training999> {
  @override
  Future<void> onLoad() async {
    addAll([
      TextBoxComponent(
        text: '[Router demo]',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0x66ffffff),
            fontSize: 16,
          ),
        ),
        align: Anchor.center,
        size: game.canvasSize,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;
}
