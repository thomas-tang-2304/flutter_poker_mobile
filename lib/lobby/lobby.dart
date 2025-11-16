import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:poker_flutter_game/components/button.dart';
import 'package:poker_flutter_game/lobby/RoomCarousel/room_carousel.dart';

class Lobby extends World with DragCallbacks {
  var game;

  late Rect _rect;
  // ignore: unused_field
  late final _paint = Paint();

  late ScrollLobby scrollLobby = ScrollLobby();
  late CreateRoomButton createRoomButton = CreateRoomButton(
      "buttons/popup_button.png", 80 * 16, -43 * 16, 400, 150, 1,
      priority: 3);

  SpriteComponent backgroundImage = SpriteComponent();

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    _rect = Rect.fromLTWH(-(game.size.x * 3.8 / 2), -(game.size.y * 3.8 / 2),
        game.size.x * 10, game.size.y * 10);

    final Path path = Path()..addRect(_rect);

    // Draw the shadow
    // canvas.drawColor(Color.fromARGB(255, 119, 69, 19), BlendMode.color);
    
  }

  @override
  FutureOr<void> onLoad() async {
    game = findGame();

    backgroundImage
      ..sprite = await Sprite.load("casino-background-21001_generated.jpg")
      ..x = 0
      ..y = 0
      ..width = game.size.x * 5
      ..height = game.size.y * 5
      ..anchor = Anchor.center;
    add(createRoomButton);
    add(backgroundImage);
    add(scrollLobby);
    return super.onLoad();
  }
  @override
  void onRemove() {
    removeAll(children.where((child) => child.isMounted));
   
  }
}
