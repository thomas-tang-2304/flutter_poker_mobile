import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:poker_flutter_game/components/button.dart';

// import 'package:poker_flutter_game/poker.dart';

class OKButton extends Button with TapCallbacks {
  // ignore: non_constant_identifier_names
  late bool isPressed;
  late String buttonPath_clicked;
  OKButton(
      // ignore: non_constant_identifier_names
      super.buttonPath,
      this.buttonPath_clicked,
      super.x,
      super.y,
      super.w,
      super.h,
      super._scale,
      this.isPressed,
      {required super.priority});

  SpriteComponent button = SpriteComponent();

  @override
  void onTapUp(TapUpEvent event) async {
    if (isPressed) {
      isPressed = false;
    } else {
      isPressed = true;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    button
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(60 * 3, 40 * 3)
      ..x = x
      ..y = y
      ..anchor = Anchor.center;
    add(button);

    return super.onLoad();
  }
}

class BetButton extends Button with TapCallbacks {
  // ignore: non_constant_identifier_names
  late bool betActive;
  late String buttonPath_clicked;
  BetButton(
      // ignore: non_constant_identifier_names
      super.buttonPath,
      this.buttonPath_clicked,
      super.x,
      super.y,
      super.w,
      super.h,
      super._scale,
      this.betActive,
      {required super.priority});

  @override
  void onTapUp(TapUpEvent event) async {
    if (betActive) {
      betActive = false;
    } else {
      betActive = true;
    }

    button.sprite = await Sprite.load(buttonPath);
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.sprite = await Sprite.load(buttonPath_clicked);
  }
}
