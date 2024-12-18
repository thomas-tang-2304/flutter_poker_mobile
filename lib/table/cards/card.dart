import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Card extends PositionComponent with TapCallbacks {
  late String buttonPath;
  late double x;
  late double y;
  late double w;
  late double h;
  late double _scale;
  late double opacity;
  late double angle;

  var _rect;

  // Generative Constructor
  // ignore: non_constant_identifier_names
  Card(String buttonPath, double x, double y, double w, double h, double angle,
      double opacity, double _scale,
      {required int priority}) {
    // ignore: prefer_initializing_formals
    this.buttonPath = buttonPath;

    // ignore: prefer_initializing_formals
    this.x = x;
    // ignore: prefer_initializing_formals
    this.y = y;

    // ignore: prefer_initializing_formals
    this.w = w;
    // ignore: prefer_initializing_formals
    this.h = h;
    // ignore: prefer_initializing_formals
    this._scale = _scale;

    // ignore: prefer_initializing_formals
    this.angle = angle;
    // ignore: prefer_initializing_formals
    this.opacity = opacity;

    this.priority = priority;

    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }

  SpriteComponent button = SpriteComponent();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());
  @override
  void onTapUp(TapUpEvent event) async {
    button.y -= 2;
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.y += 2;
  }

  @override
  FutureOr<void> onLoad() async {
    button
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(w * _scale, h * _scale)
      ..x = x
      ..y = y
      ..angle = angle
      ..opacity = opacity
      ..anchor = Anchor.center;
    await add(button);
    priority = 1;

    return super.onLoad();
  }
}
