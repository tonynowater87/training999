import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// Sound effects. Files live in `assets/audio/effect/`.
enum Sfx {
  explosion('explosion.mp3', maxPlayers: 1, volume: 1.0),
  menuSelect('menu_select.mp3', maxPlayers: 3, volume: 1.0),
  graze('graze.wav', maxPlayers: 4, volume: 0.5),
  itemReady('item_ready.wav', maxPlayers: 1, volume: 0.8),
  shieldOn('shield_on.wav', maxPlayers: 1, volume: 0.8),
  shieldBreak('shield_break.wav', maxPlayers: 2, volume: 0.9),
  bomb('bomb.wav', maxPlayers: 1, volume: 1.0),
  slow('slow.wav', maxPlayers: 1, volume: 0.8),
  shrink('shrink.wav', maxPlayers: 1, volume: 0.8),
  titleUp('title_up.wav', maxPlayers: 1, volume: 0.7),
  warning('warning.wav', maxPlayers: 1, volume: 0.6);

  const Sfx(this.file, {required this.maxPlayers, required this.volume});

  final String file;
  final int maxPlayers;
  final double volume;

  String get path => 'effect/$file';
}

class MusicManager {
  static const String _bgmPath = 'music/bgm.mp3';
  static const double _bgmVolume = 0.4;

  /// Minimum time between two graze sounds, so a burst of near misses does
  /// not turn into noise.
  static const Duration _grazeInterval = Duration(milliseconds: 80);

  final Map<Sfx, AudioPool> _pools = {};
  DateTime _lastGrazeAt = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> init() async {
    await FlameAudio.audioCache
        .loadAll([_bgmPath, ...Sfx.values.map((sfx) => sfx.path)]);
    for (final sfx in Sfx.values) {
      try {
        _pools[sfx] =
            await FlameAudio.createPool(sfx.path, maxPlayers: sfx.maxPlayers);
      } catch (error) {
        // A missing sound must never block the game from starting.
        debugPrint('[MusicManager] Failed to load ${sfx.path}: $error');
      }
    }
  }

  Future<void> playBgm() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play(_bgmPath, volume: _bgmVolume);
  }

  void play(Sfx sfx) {
    if (sfx == Sfx.graze) {
      final now = DateTime.now();
      if (now.difference(_lastGrazeAt) < _grazeInterval) {
        return;
      }
      _lastGrazeAt = now;
    }
    _pools[sfx]?.start(volume: sfx.volume);
  }

  void playExplosion() => play(Sfx.explosion);

  void playMenuSelect() => play(Sfx.menuSelect);
}
