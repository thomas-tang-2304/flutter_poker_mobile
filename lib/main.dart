import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poker_flutter_game/lobby/widgets/create_join_room_form.dart';
// import 'package:poker_flutter_game/table/index.dart';
import 'package:poker_flutter_game/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  RouterGame game = RouterGame();

  runApp(MaterialApp(
      home: Scaffold(
          body: Stack(children: [
    GameWidget(
      game: kDebugMode ? RouterGame() : game,
      overlayBuilderMap: {
        'roomCodePopup': (BuildContext context, RouterGame game) {
          return CreateJoinRoomForm(game);
        },
      },
    ),
  ]))));
}
