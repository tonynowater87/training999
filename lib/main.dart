import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/firebase_options.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/my_provider_observer.dart';
import 'package:training999/widget/enter_name_widget.dart';
import 'package:training999/widget/ranking_list_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final game = Training999();
  runApp(ProviderScope(
    observers: [MyProviderObserver()],
    child: MaterialApp(
      home: Scaffold(
        // Keep the keyboard from resizing the game canvas (stars would move up).
        resizeToAvoidBottomInset: false,
        body: RiverpodAwareGameWidget<Training999>(
          overlayBuilderMap: {
            'enter_name': (context, game) => const EnterNameWidget(),
            'rank': (context, game) {
              return RankingListWidget(
                voidCallback: () {
                  game.reset();
                  game.overlays.remove('rank');
                  game.router.pushNamed("menu");
                },
              );
            }
          },
          game: game,
          key: GlobalKey(),
        ),
      ),
    ),
  ));
}
