import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:poker_flutter_game/utils/text_render.dart';

class Chip extends PositionComponent with TapCallbacks {
  late String buttonPath;
  late double x;
  late double y;
  late double w;
  late double h;
  late double _scale;
  late double angle;
  late int currency;

  var _rect;
  late TextComponent<TextRenderer> currencyText = TextComponent(
    text: currency.toString(),
    anchor: Anchor.center,
    position: Vector2(x, y),
    angle: angle,
    textRenderer: chip_currency_regular,
  );

  // Generative Constructor

  Chip.c1(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 1;
    buttonPath = "chips/image_part_001.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }

  Chip.c5(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 5;
    buttonPath = "chips/image_part_001.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }
  Chip.c10(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 10;
    buttonPath = "chips/image_part_002.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }
  Chip.c25(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 25;
    buttonPath = "chips/image_part_002.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }
  Chip.c50(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 50;
    buttonPath = "chips/image_part_003.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }
  Chip.c100(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 100;
    buttonPath = "chips/image_part_003.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }
  Chip.c500(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 500;
    buttonPath = "chips/image_part_004.png";
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }
  Chip.c1000(this.x, this.y, this.w, this.h, this.angle, this._scale,
      {required int priority}) {
    currency = 1000;
    buttonPath = "chips/image_part_004.png";
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
      ..anchor = Anchor.center;
    await add(button);
    await add(currencyText);
    priority = 1;

    return super.onLoad();
  }
}
