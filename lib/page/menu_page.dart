import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:training999/components/rounded_button.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/training_999.dart';

class MenuPage extends Component
    with HasGameReference<Training999>, RiverpodComponentMixin {
  bool isNameExisted = false;

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(myNameProvider, (previous, myName) {
        debugPrint('[TONY] MenuPage, myName: $myName');
        if (myName.hasValue) {
          isNameExisted = myName.value!.name.isNotEmpty;
          if (isNameExisted && !contains(_button1)) {
            add(_button1);
          }
          if (isNameExisted && !contains(_button2)) {
            add(_button2);
          }
          if (!isNameExisted && !game.overlays.isActive('enter_name')) {
            game.overlays.add('enter_name');
          }
        }
      });
    });
    super.onMount();
  }

  @override
  Future<void> onLoad() async {
    _logo = TextComponent(
      text: '特訓999',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 64,
          color: Color(0xFFC8FFF5),
          fontWeight: FontWeight.w800,
        ),
      ),
      anchor: Anchor.center,
    );
    _button1 = RoundedButton(
      text: '開始遊戲',
      action: () {
        game.musicManager.playMenuSelect();
        game.router.pop();
        game.start();
      },
      color: const Color(0xffadde6c),
      borderColor: const Color(0xffedffab),
    );
    _button2 = RoundedButton(
      text: '排行榜',
      action: () {
        game.musicManager.playMenuSelect();
        if (game.overlays.isActive('rank')) {
          game.overlays.remove('rank');
        } else {
          game.overlays.add('rank');
        }
      },
      color: const Color(0xffadde6c),
      borderColor: const Color(0xffedffab),
    );

    if (isNameExisted) {
      addAll([
        _logo,
        _button1,
        _button2,
      ]);
    } else {
      addAll([_logo]);
    }
  }

  late final TextComponent _logo;
  late final RoundedButton _button1;
  late final RoundedButton _button2;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
    _button2.position = Vector2(size.x / 2, _logo.y + 130);
  }

  @override
  bool containsPoint(Vector2 point) => true;

  @override
  void onRemove() {
    super.onRemove();
  }
}
