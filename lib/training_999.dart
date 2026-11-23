import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:training999/components/airplane.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/components/bullet_easy.dart';
import 'package:training999/components/bullet_hard.dart';
import 'package:training999/components/bullet_mid.dart';
import 'package:training999/components/explosion.dart';
import 'package:training999/components/info_text.dart';
import 'package:training999/components/score_text.dart';
import 'package:training999/components/star_background_creator.dart';
import 'package:training999/page/menu_page.dart';
import 'package:training999/page/splash_page.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/provider/rank/all_rank_provider.dart';
import 'package:training999/provider/rank/model/rank.dart';
import 'package:training999/provider/rank/my_latest_rank_provider.dart';
import 'package:training999/provider/uuid/get_uuid.dart';
import 'package:training999/util/bullet_level.dart';
import 'package:training999/util/music_manager.dart';
import 'package:training999/util/player_title.dart';

import 'components/detect_close_to_bullet.dart';

class Training999 extends FlameGame
    with
        RiverpodGameMixin,
        DragCallbacks,
        TapCallbacks,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  /// Player speed in pixels per second at full joystick tilt / key press.
  static const double playerSpeed = 150;

  /// Upper bound for a single simulation step. Frames slower than this are
  /// simulated in slow motion instead of letting objects jump (tunneling).
  /// Survive time uses the same clamped value, so scoring stays fair.
  static const double _maxStepTime = 1 / 30;

  /// Spawn bullets slightly outside the screen corners.
  static const double _spawnMargin = 8;

  /// Extra distance a bullet may travel past the spawn circle before removal.
  static const double _despawnMargin = 50;

  /// Every [_densityStepSeconds] the easy bullet period is multiplied by
  /// [_densityFactor], down to [_minEasyPeriod].
  static const int _densityStepSeconds = 10;
  static const double _densityFactor = 0.9;
  static const double _minEasyPeriod = 0.04;

  /// A ring of bullets closes in on the player every [_ringIntervalSeconds].
  static const int _ringIntervalSeconds = 20;
  static const int _ringBaseBulletCount = 16;
  static const int _ringMaxBulletCount = 32;
  static const Color _ringBulletColor = Color(0xFF66E0FF);

  /// Vertical distance between announcements shown in the same second.
  static const double _announcementLineHeight = 30;

  /// Timeout for uploading a record, so an offline device never blocks the
  /// game-over flow (Firestore writes wait for the server acknowledgement).
  static const Duration _uploadTimeout = Duration(seconds: 5);

  static final Set<LogicalKeyboardKey> _upKeys = {
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.keyW,
  };
  static final Set<LogicalKeyboardKey> _downKeys = {
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.keyS,
  };
  static final Set<LogicalKeyboardKey> _leftKeys = {
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyA,
  };
  static final Set<LogicalKeyboardKey> _rightKeys = {
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyD,
  };

  late Airplane player;
  late DetectCloseToBullet detectCloseToBullet;
  late JoystickComponent joystickLeft;
  late JoystickComponent joystickRight;
  bool isGameOver = true;
  int gameTime = 0;
  int brilliantlyDodgedTheBullet = 0;
  double _survivedSeconds = 0;
  SpawnComponent? _easySpawner;
  int _titleIndex = 0;
  int _announcementSlot = 0;

  late final RouterComponent router;
  final Set<LogicalKeyboardKey> pressedKeySets = {};
  String myName = '';
  MusicManager musicManager = MusicManager();
  final Random _rng = Random();

  Training999() : super();

  /// Survive time of the current run in milliseconds.
  int get surviveTime => (_survivedSeconds * 1000).round();

  /// Distance from the screen center to a corner.
  double get gameSizeOfRadius => size.length / 2;

  double get _bulletSpawnRadius => gameSizeOfRadius + _spawnMargin;

  double get bulletDespawnRadius => _bulletSpawnRadius + _despawnMargin;

  @override
  bool get pauseWhenBackgrounded => true;

  @override
  Color backgroundColor() => const Color(0xFF001030);

  @override
  Future onLoad() async {
    await super.onLoad();
    await musicManager.init();
    musicManager.playBgm();
    add(router = RouterComponent(initialRoute: "splash", routes: {
      'splash': Route(SplashPage.new),
      'menu': Route(MenuPage.new),
    }));

    await images.loadAllImages();
    player = Airplane();
    detectCloseToBullet = DetectCloseToBullet();
    add(StarBackGroundCreator());
    initJoystick();
  }

  @override
  void onMount() {
    ref.read(allRankProvider); // Trigger allRankProvider build early.
    addToGameWidgetBuild(() {
      // Riverpod can only be used from here.
      ref.listen(myNameProvider, (previous, current) {
        if (current.hasValue && current.value!.name.isNotEmpty) {
          myName = current.value!.name;
          overlays.remove("enter_name");
        }
      }, onError: (error, stackTrace) {
        debugPrint('[Training999] Failed to load my name: $error');
      });
    });
    super.onMount();
  }

  void start() {
    isGameOver = false;
    overlays.clear();
    if (!player.isMounted) {
      add(player);
      add(detectCloseToBullet);
    }
    if (!joystickLeft.isMounted || !joystickRight.isMounted) {
      addJoystick();
    }

    detectCloseToBullet.position = player.position;
    _titleIndex = 0;
    add(TimerComponent(
        period: 1,
        repeat: true,
        autoStart: true,
        removeOnFinish: true,
        onTick: () {
          if (isGameOver) {
            return;
          }
          _announcementSlot = 0;

          if (gameTime == 0) {
            _easySpawner = addBullet(BulletLevel.easy);
            _announce('Game Start!');
          }

          if (gameTime > 0 && gameTime % 15 == 0) {
            addBullet(BulletLevel.middle);
            _announce('高速彈發射!');
          }

          if (gameTime > 0 && gameTime % 25 == 0) {
            addBullet(BulletLevel.hard);
            _announce('誘導彈發射!');
          }

          if (gameTime > 0 && gameTime % _ringIntervalSeconds == 0) {
            _spawnRing();
            _announce('包圍彈來襲!');
          }

          if (gameTime > 0 && gameTime % _densityStepSeconds == 0) {
            _increaseEasyDensity();
          }
          gameTime++;
        }));
  }

  /// Shows a short announcement at the top; several announcements in the same
  /// second are stacked instead of overlapping.
  void _announce(String text) {
    add(InfoTextComponent(text,
        Vector2(size.x / 2, _announcementSlot * _announcementLineHeight)));
    _announcementSlot++;
  }

  void _increaseEasyDensity() {
    final spawner = _easySpawner;
    if (spawner == null || spawner.period <= _minEasyPeriod) {
      return;
    }
    spawner.period = max(_minEasyPeriod, spawner.period * _densityFactor);
    _announce('彈幕密度上升!');
  }

  /// Spawns a ring of bullets on the spawn circle, all flying towards the
  /// player's current position. Stay still and you are surrounded.
  void _spawnRing() {
    final count = min(_ringMaxBulletCount,
        _ringBaseBulletCount + gameTime ~/ _ringIntervalSeconds * 2);
    final target = player.position.clone();
    final rotation = _rng.nextDouble() * 2 * pi;
    for (var i = 0; i < count; i++) {
      final radians = rotation + 2 * pi * i / count;
      final position =
          Vector2(cos(radians), sin(radians)) * _bulletSpawnRadius + size / 2;
      add(BulletEasy(position, target: target, color: _ringBulletColor));
    }
  }

  SpawnComponent addBullet(BulletLevel bulletLevel) {
    final spawner = SpawnComponent(
        selfPositioning: true,
        factory: (int amount) {
          final radians = _rng.nextDouble() * 2 * pi;
          final position =
              Vector2(cos(radians), sin(radians)) * _bulletSpawnRadius +
                  size / 2;
          switch (bulletLevel) {
            case BulletLevel.easy:
              return BulletEasy(position,
                  angleOffset: BulletEasy.randomSpread(_rng));
            case BulletLevel.middle:
              return BulletMid(position);
            case BulletLevel.hard:
              return BulletHard(position);
          }
        },
        period: bulletLevel.getPeriod());
    add(spawner);
    return spawner;
  }

  void addBrilliantlyDodgedTheBulletText() {
    brilliantlyDodgedTheBullet++;
    add(InfoTextComponent('絕妙度過子彈！', size / 2));
  }

  @override
  void updateTree(double dt) {
    super.updateTree(min(dt, _maxStepTime));
  }

  @override
  void update(double dt) {
    if (!isGameOver) {
      // Accumulate simulated time only, so paused (backgrounded) time and
      // slow devices cannot inflate the score.
      _survivedSeconds += dt;
      _movePlayer(dt);
      _checkTitleUpgrade();
    }
    super.update(dt);
  }

  void _checkTitleUpgrade() {
    final index = titleIndexFor(surviveTime);
    if (index <= _titleIndex) {
      return;
    }
    _titleIndex = index;
    add(InfoTextComponent(
        '稱號升級：${playerTitles[index].name}', Vector2(size.x / 2, size.y / 4)));
  }

  /// Title of the current (or just finished) run.
  String get currentFullTitle =>
      fullTitleFor(surviveTime, brilliantlyDodgedTheBullet);

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    // Always track the current state, so a key released during game over
    // does not keep moving the player in the next run.
    pressedKeySets
      ..clear()
      ..addAll(keysPressed.where(_isMovementKey));

    if (isGameOver) {
      return KeyEventResult.ignored;
    }
    return _isMovementKey(event.logicalKey)
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }

  bool _isMovementKey(LogicalKeyboardKey key) =>
      _upKeys.contains(key) ||
      _downKeys.contains(key) ||
      _leftKeys.contains(key) ||
      _rightKeys.contains(key);

  void initJoystick() {
    joystickLeft = _createJoystick(Vector2(64, canvasSize.y - 64));
    joystickRight =
        _createJoystick(Vector2(canvasSize.x - 64, canvasSize.y - 64));
  }

  JoystickComponent _createJoystick(Vector2 position) {
    return JoystickComponent(
        priority: 10,
        knob: SpriteComponent(
          size: Vector2(50, 50),
          sprite: Sprite(images.fromCache('Knob.png')),
        ),
        background: SpriteComponent(
          size: Vector2(64, 64),
          sprite: Sprite(images.fromCache('Joystick.png')),
        ),
        position: position);
  }

  void addJoystick() {
    add(joystickLeft);
    add(joystickRight);
  }

  Future<void> gameover() async {
    // Several bullets can hit the player in the same frame; only the first
    // hit may end the game, otherwise the record is uploaded twice.
    if (isGameOver) {
      return;
    }
    isGameOver = true;
    musicManager.playExplosion();
    // Stop spawning before the (possibly slow) upload starts.
    removeWhere((c) =>
        c is JoystickComponent || c is TimerComponent || c is SpawnComponent);

    final myNameState = ref.read(myNameProvider);
    final now = Timestamp.now();
    final rank = Rank(
        id: now.millisecondsSinceEpoch,
        name: myNameState.hasValue ? myNameState.value!.name : myName,
        uuid: await _readUuid(),
        survivedTimeInMilliseconds: surviveTime,
        brilliantlyDodgedTheBullets: brilliantlyDodgedTheBullet,
        platform: _platformName,
        createdAt: now);
    ref.read(myLatestRankProvider.notifier).set(rank);
    try {
      // Wait for the upload, otherwise the ranking shows stale data first.
      await ref
          .read(allRankProvider.notifier)
          .insertRecord(rank)
          .timeout(_uploadTimeout);
    } catch (error) {
      debugPrint('[Training999] Failed to upload rank: $error');
    }

    if (!children.any((c) => c is ScoreText)) {
      add(ScoreText());
    }
    overlays.add('rank');
  }

  Future<String?> _readUuid() async {
    try {
      return await ref.read(getUuidProvider.future);
    } catch (error) {
      debugPrint('[Training999] Failed to read uuid: $error');
      return null;
    }
  }

  static String get _platformName {
    if (kIsWeb) {
      return 'Web';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  void reset() {
    overlays.remove('rank');
    removeWhere((c) =>
        c is Bullet ||
        c is TimerComponent ||
        c is SpawnComponent ||
        c is ExplosionComponent ||
        c is ScoreText);
    gameTime = 0;
    _survivedSeconds = 0;
    _easySpawner = null;
    _titleIndex = 0;
    brilliantlyDodgedTheBullet = 0;
    pressedKeySets.clear();
    player.position = size / 2;
  }

  void _movePlayer(double dt) {
    final direction = joystickLeft.relativeDelta + joystickRight.relativeDelta
      ..add(_keyboardDirection());
    // Cap at full speed, so diagonals and two joysticks are not faster.
    if (direction.length2 > 1) {
      direction.normalize();
    }
    player.position.addScaled(direction, playerSpeed * dt);
  }

  Vector2 _keyboardDirection() {
    final direction = Vector2.zero();
    if (pressedKeySets.any(_upKeys.contains)) direction.y -= 1;
    if (pressedKeySets.any(_downKeys.contains)) direction.y += 1;
    if (pressedKeySets.any(_leftKeys.contains)) direction.x -= 1;
    if (pressedKeySets.any(_rightKeys.contains)) direction.x += 1;
    return direction;
  }
}
