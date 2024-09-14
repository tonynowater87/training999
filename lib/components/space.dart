import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Space extends World with HasCollisionDetection {
  Space() : super(children: []);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }
}
