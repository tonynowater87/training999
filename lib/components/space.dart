import 'package:flame/components.dart';

class Space extends World with HasCollisionDetection {
  Space() : super(children: [ScreenHitbox()..debugMode = true]);
}
