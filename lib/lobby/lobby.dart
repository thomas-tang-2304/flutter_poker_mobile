import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:poker_flutter_game/lobby/Paralax/paralax_background.dart';

class Lobby extends World with DragCallbacks {
  var game;

  late Rect _rect;
  // ignore: unused_field
  late final _paint = Paint();

  late ScrollLobby scrollLobby = ScrollLobby();

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _rect = Rect.fromLTWH(-(game.size.x * 3.8 / 2), -(game.size.y * 3.8 / 2),
        game.size.x * 10, game.size.y * 10);

    final Path path = Path()..addRect(_rect);

    // Draw the shadow
    canvas.drawColor(Color.fromARGB(255, 119, 69, 19), BlendMode.color);
    
  }

  @override
  FutureOr<void> onLoad() async {
    game = findGame();

    add(scrollLobby);
    return super.onLoad();
  }
}
