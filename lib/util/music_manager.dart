import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

class MusicManager {

  init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'music/bgm.mp3',
    ]);
  }

  void playBgm() {
    FlameAudio.bgm.play('music/bgm.mp3', volume: 0.5);
  }

  Future<void> playExplosion() async {
    // TODO 處理音效播放, 不能影響遊戲流暢度和bgm

  }

  Future<void> playMenuSelect() async {
    // TODO 處理音效播放, 不能影響遊戲流暢度和bgm
  }

}