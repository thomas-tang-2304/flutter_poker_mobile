import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Draggable;

// import 'package:poker_flutter_game/poker.dart';

// class ThumbDragger extends SpriteComponent with Draggable {
//   Vector2? dragDeltaPosition;

//   ThumbDragger({required Vector2 position }): super(position: position, size: Vector2.all(16));
// }

class Thumb extends Component with DragCallbacks {
  late String buttonPath;
  late double x;
  late double y;

  late Rect _rect;
  // ignore: unused_field
  late final _paint = Paint();
  // ignore: unused_field
  late bool _isDragged = false;
  // ignore: prefer_typing_uninitialized_variables
  late Vector2 position;

  final double limitEnd = 290;
  final double limitStart = -290;

  @override
  void onDragStart(DragStartEvent event) {
    _isDragged = true;
    super.onDragStart(event);
  }

  @override
  // ignore: deprecated_member_use
  void onDragUpdate(DragUpdateEvent event) {
    position += event.delta;
    if (position[1] >= limitStart && position[1] <= limitEnd) {
      _rect = Rect.fromLTWH(x - 18 * 3, position[1] - 32 * 3, 18 * 6, 32 * 6);
      thumb
        ..x = x
        ..y = position[1];
    }

    if (position[1] < limitStart) {
      position[1] = limitStart;
      _rect = Rect.fromLTWH(x - 18 * 3, limitStart - 32 * 3, 18 * 6, 32 * 6);
      thumb
        ..x = x
        ..y = limitStart;
    }

    if (position[1] > limitEnd) {
      position[1] = limitEnd;
      _rect = Rect.fromLTWH(x - 18 * 3, limitEnd - 32 * 3, 18 * 6, 32 * 6);
      thumb
        ..x = x
        ..y = limitEnd;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  // Generative Constructor
  // ignore: non_constant_identifier_names
  Thumb(String buttonPath, double x, double y) {
    // ignore: prefer_initializing_formals
    this.buttonPath = buttonPath;

    // ignore: prefer_initializing_formals
    this.x = x;
    // ignore: prefer_initializing_formals
    this.y = y;
    position = Vector2(x, y);
    _rect = Rect.fromLTWH(x - 18 * 2.5, y - 32 * 2.5, 18 * 5, 32 * 5);
  }

  SpriteComponent thumb = SpriteComponent();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());

  @override
  FutureOr<void> onLoad() async {
    thumb
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(18 * 5, 32 * 5)
      ..x = x
      ..y = y
      ..anchor = Anchor.center;
    add(thumb);

    return super.onLoad();
  }
}
