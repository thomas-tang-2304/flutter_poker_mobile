import 'dart:convert';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:poker_flutter_game/components/bar_navigation.dart';
import 'package:poker_flutter_game/home/index.dart';
import 'package:poker_flutter_game/lobby/index.dart';
import 'package:poker_flutter_game/player/player.dart';
import 'package:poker_flutter_game/table/index.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';

class RouterGame extends FlameGame with TapCallbacks {
  late Player player = Player.justID(const Uuid().v1());

  late dynamic rooms = {};
  late bool menuPopupToggle = false;
  late NavBar navBar = NavBar();
  late Socket socket;
  @override
  Color backgroundColor() => Color.fromARGB(255, 119, 69, 19);
  late final RouterComponent router = RouterComponent(
    routes: {
      'home': Route(HomePage.new),
      'gameplay': Route(Poker.new),
      "lobby": Route(LobbyPage.new)
    },
    initialRoute: 'home',
  );

  @override
  void onLoad() async {
    try {
      socket = io("http://localhost:3001", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        // 'query': {'token': 'THIS IS MY TOKEN FOR AUTHENTICATION'}
      });

      socket.onConnect((_) {
        print('connect');
      });

      socket.on("sample-rooms", (handler) {
        rooms = handler;
      });

      // print(socket);
    } catch (err) {
      print('ConnectionScreen -> initState -> err ->');
      print(err);
    }
    add(navBar);
    add(camera);
    add(router);
  }

  @override
  void update(double dt) {
    if (menuPopupToggle) {
      super.add(navBar.menuPopup);
    } else {
      if (navBar.menuPopup.isMounted) {
        super.remove(navBar.menuPopup);
      }
    }
    super.update(dt);
  }
}
