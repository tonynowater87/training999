import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

class MusicManager {

  init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'music/bgm.mp3',
      'effect/explosion.mp3',
      'effect/menu_select.mp3'
    ]);
  }

  void playBgm() {
    FlameAudio.bgm.play('music/bgm.mp3', volume: 0.5);
  }

  Future<void> playExplosion() async {
    FlameAudio.play('effect/explosion.mp3');

  }

  Future<void> playMenuSelect() async {
    FlameAudio.play('effect/menu_select.mp3');
  }

}