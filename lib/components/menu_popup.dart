import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:poker_flutter_game/components/button.dart';
import 'package:poker_flutter_game/home/index.dart';
import 'package:poker_flutter_game/lobby/index.dart';
import 'package:poker_flutter_game/utils/text_render.dart';

class Popup extends PositionComponent with TapCallbacks {
  var game;
  late String buttonPath;
  late double x;
  late double y;
  late double w;
  late double h;
  late final double _scale;

  late QuitButton quitButton = QuitButton("Quit", 'buttons/popup_button_3.png',
      game.size.x / 2, game.size.y / 2, 217, 60, game.size.y / 700);
  late ExitRoomButton exitRoomButton = ExitRoomButton(
      "Exit",
      'buttons/popup_button_3.png',
      game.size.x / 2,
      game.size.y / 2 + (game.size.y / 700) * 100,
      217,
      60,
      game.size.y / 700);

  late CloseButton closeButton = CloseButton(
      'buttons/close_button.png',
      game.size.x / 2,
      game.size.y / 2 + game.size.y / 2.8,
      75,
      75,
      game.size.y / 700,
      priority: 1);

  late TextComponent<TextRenderer> renderText = TextComponent(
    text: "TITLE",
    anchor: Anchor.center,
    position: Vector2(game.size.x / 2, game.size.y / 2 - game.size.y / 3.2),
    textRenderer: regular,
  );

  // ignore: unused_field, prefer_typing_uninitialized_variables
  var _rect;

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());

  // Generative Constructor
  // ignore: non_constant_identifier_names
  Popup(this.buttonPath, this.x, this.y, this.w, this.h, this._scale,
      int priority) {
    this.priority = priority;
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }

  SpriteComponent button = SpriteComponent();

  @override
  FutureOr<void> onLoad() async {
    game = findGame();
    button
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(w * _scale, h * _scale)
      ..x = x
      ..y = y
      ..anchor = Anchor.center;
    await add(button);
    await add(closeButton);
    await add(renderText);

    await add(exitRoomButton);
    await add(quitButton);

    return super.onLoad();
  }
}

class CloseButton extends Button with TapCallbacks {
  CloseButton(
      super.buttonPath, super.x, super.y, super.w, super.h, super._scale,
      {required super.priority});

  @override
  void onTapUp(TapUpEvent event) {
    // print(game);
    super.game.menuPopupToggle = false;

    super.onTapUp(event);
  }
}

class MenuButton extends Button with TapCallbacks {
  MenuButton(super.buttonPath, super.x, super.y, super.w, super.h, super._scale,
      {required super.priority});

  @override
  void onTapUp(TapUpEvent event) {
    super.game.menuPopupToggle = true;

    super.onTapUp(event);
  }

  @override
  FutureOr<void> onLoad() {
    // add(menuPopup);
    return super.onLoad();
  }
}

class PopupButtonWithText extends Button with TapCallbacks {
  late String popupText;
  var game;
  PopupButtonWithText(this.popupText, super.buttonPath, super.x, super.y,
      super.w, super.h, super._scale)
      : super(priority: 2);

  late TextComponent<TextRenderer> renderText = TextComponent(
      text: popupText,
      anchor: Anchor.center,
      position: Vector2(x, y),
      textRenderer: popup_regular,
      priority: 5);

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    // ignore: unused_local_variable

    game = findGame();

    add(renderText);
    return super.onLoad();
  }
}

class QuitButton extends PopupButtonWithText {
  QuitButton(super.popupText, super.buttonPath, super.x, super.y, super.w,
      super.h, super.scale);

  @override
  void onTapUp(TapUpEvent event) async {
    game.menuPopupToggle = false;
    await game.router.pop();
    await game.router.pushRoute(Route(HomePage.new));
    super.onTapUp(event);
  }
}

class ExitRoomButton extends PopupButtonWithText {
  ExitRoomButton(super.popupText, super.buttonPath, super.x, super.y, super.w,
      super.h, super.scale);

  @override
  void onTapUp(TapUpEvent event) async {
    game.menuPopupToggle = false;
    await game.socket.emit('leave', {
      "roomCode": game.player.roomId,
      "username": game.player.name,
      "gameBalance": game.player.cash
    });
    await game.router.pop();
    await game.router.pushRoute(Route(LobbyPage.new));
    super.onTapUp(event);
  }
}
