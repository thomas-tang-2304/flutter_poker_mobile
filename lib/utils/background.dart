import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:poker_flutter_game/router.dart';

class Background extends SpriteComponent with HasGameRef<RouterGame> {
  Background();
  final _rect = const Rect.fromLTWH(0, 0, 200 * 16, 40 * 16);
  final _paint = Paint();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _paint.color = Color.fromARGB(121, 108, 108, 108);
    canvas.drawRect(_rect, _paint);
  }

  Future<void> onLoad() async {
    final background = await Flame.images
        .load("p_866bcf32-35bd-11ef-94df-169ce54c9032_wm.png");
    size = game.size;
    sprite = Sprite(background);
  }
}
