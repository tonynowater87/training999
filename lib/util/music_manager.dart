import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

class MusicManager {
  late AudioPool _explosionPool; // 宣告 AudioPool 實例
  late AudioPool _menuSelectPool;

  init() async {
    await FlameAudio.audioCache.loadAll(
        ['music/bgm.mp3', 'effect/explosion.mp3', 'effect/menu_select.mp3']);

    // 初始化 AudioPool
    _explosionPool =
        await FlameAudio.createPool('effect/explosion.mp3', maxPlayers: 1);
    _menuSelectPool =
        await FlameAudio.createPool('effect/menu_select.mp3', maxPlayers: 3);
  }

  Future<void> playBgm() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music/bgm.mp3', volume: 0.5);
  }

  Future<void> playExplosion() async {
    _explosionPool.start();
  }

  Future<void> playMenuSelect() async {
    _menuSelectPool.start();
  }
}
