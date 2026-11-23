import 'package:flame/components.dart';
import 'package:training999/components/logo.dart';
import 'package:training999/training_999.dart';

class SplashPage extends Component with HasGameReference<Training999> {
  late LogoComponent _logo;

  @override
  Future<void> onLoad() async {
    add(_logo = LogoComponent());
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onGameResize(Vector2 size) {
    _logo.position = Vector2(size.x / 2, size.y / 3);
    super.onGameResize(size);
  }

  @override
  void onMount() {
    remove(_logo);
    game.router.pushNamed('menu');
    super.onMount();
  }
}
