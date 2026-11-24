import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:training999/art/ui_painter.dart';
import 'package:training999/art/ui_theme.dart';
import 'package:training999/components/logo.dart';
import 'package:training999/components/rounded_button.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/training_999.dart';

class MenuPage extends Component
    with HasGameReference<Training999>, RiverpodComponentMixin {
  bool isNameExisted = false;

  late final LogoComponent _logo;
  late final RoundedButton _button1;
  late final RoundedButton _button2;
  late final _PilotLabel _pilotLabel;

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(myNameProvider, (previous, myName) {
        debugPrint('[TONY] MenuPage, myName: $myName');
        if (myName.hasValue) {
          isNameExisted = myName.value!.name.isNotEmpty;
          _pilotLabel.name = myName.value!.name;
          for (final component in [_button1, _button2, _pilotLabel]) {
            if (isNameExisted && !contains(component)) {
              add(component);
            }
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
    _logo = LogoComponent();
    _pilotLabel = _PilotLabel();
    _button1 = RoundedButton(
      text: '開始遊戲',
      hint: 'ENTER',
      action: () {
        game.musicManager.playMenuSelect();
        game.router.pop();
        game.start();
      },
      accent: UiColors.cyan,
      shortcutKeys: {LogicalKeyboardKey.enter, LogicalKeyboardKey.space},
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
      accent: UiColors.pink,
    );

    add(_logo);
    if (isNameExisted) {
      addAll([_button1, _button2, _pilotLabel]);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y * 0.3);
    _button1.position = Vector2(size.x / 2, _logo.y + 92);
    _button2.position = Vector2(size.x / 2, _logo.y + 148);
    _pilotLabel.position = Vector2(size.x / 2, _logo.y + 186);
  }

  @override
  bool containsPoint(Vector2 point) => true;
}

/// "PILOT  name" under the menu buttons.
class _PilotLabel extends PositionComponent {
  _PilotLabel() : super(anchor: Anchor.topCenter);

  final TextPainter _label = UiPainter.layoutText('PILOT',
      fontSize: 10,
      color: UiColors.cyan,
      fontWeight: FontWeight.w800,
      letterSpacing: 3);
  TextPainter? _name;

  set name(String value) {
    _name = UiPainter.layoutText(value, fontSize: 14, color: UiColors.textDim);
  }

  @override
  void render(Canvas canvas) {
    final name = _name;
    if (name == null) {
      return;
    }
    final total = _label.width + 8 + name.width;
    UiPainter.drawText(canvas, _label, Offset(-total / 2, 0));
    UiPainter.drawText(canvas, name, Offset(-total / 2 + _label.width + 8, -2));
  }
}
