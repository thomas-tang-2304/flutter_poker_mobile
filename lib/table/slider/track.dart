import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// import 'package:poker_flutter_game/poker.dart';

class Track extends Component with TapCallbacks {
  late String buttonPath;
  late double x;
  late double y;

  late Rect _rect;
  // ignore: unused_field
  late final _paint = Paint();

  // Generative Constructor
  // ignore: non_constant_identifier_names
  Track(String buttonPath, double x, double y) {
    // ignore: prefer_initializing_formals
    this.buttonPath = buttonPath;

    // ignore: prefer_initializing_formals
    this.x = x;
    // ignore: prefer_initializing_formals
    this.y = y;

    _rect = Rect.fromLTWH(x - 32 * 5, y - 160 * 5, 32 * 10, 160 * 10);
  }

  SpriteComponent track = SpriteComponent();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());
  @override
  void onTapUp(TapUpEvent event) async {
    print(buttonPath);
    // track.sprite = await loadSprite(buttonPath);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // _paint.color = const Color.fromARGB(52, 0, 0, 0);
    // canvas.drawRect(_rect, _paint);

    // Define the path for the rectangle
    final Path path = Path()..addRect(_rect);

    // Draw the shadow
    canvas.drawShadow(path, Colors.black, 5.0, false);
  }

  @override
  FutureOr<void> onLoad() async {
    track
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(32 * 5, 160 * 5)
      ..x = x
      ..y = y
      ..anchor = Anchor.center;
    add(track);

    return super.onLoad();
  }
}
