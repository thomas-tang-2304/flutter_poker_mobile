import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:poker_flutter_game/components/button.dart';
import 'package:poker_flutter_game/table/table.dart';

// import 'package:poker_flutter_game/poker.dart';

class OKButton extends Button with TapCallbacks, HasWorldReference<PokerTable> {
  // ignore: non_constant_identifier_names
  var game;
  late double betNumber = 0.0;
  late bool isPressed;
  late String buttonPath_clicked;

  OKButton(
      // ignore: non_constant_identifier_names
      super.buttonPath,
      this.buttonPath_clicked,
      this.betNumber,
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
    game.player.bet = betNumber;
    // print(game.player.roomBet);

    world.betButtonComponent.betActive = false;
    if (game.player.lastBet < betNumber) {
      if (game.player.lastBet > 0.0) {
        await game.socket.emit("get-turn", {
          "roomCode": game.player.roomId,
          "reset": true,
          "userBetNumber": betNumber
        });
      } else {
        // print('turn: ${game.player.turn}');
        if (game.player.turn > 0) {
          await game.socket.emit("get-turn", {
            "roomCode": game.player.roomId,
            "reset": true,
            "userBetNumber": betNumber
          });
        } else {
          await game.socket.emit("get-turn", {
            "roomCode": game.player.roomId,
            "reset": false,
            "userBetNumber": betNumber
          });
        }
      }
    } else {
      await game.socket.emit("get-turn", {
        "roomCode": game.player.roomId,
        "reset": false,
        "userBetNumber": betNumber
      });
    }
    // print("bet button: "+ game.player.bet.toString());
    world.thumbComponent.position[1] = world.thumbComponent.limitEnd;
    betNumber = 0.0;
    world.curBalance.text = game.player.cash.toString();
  }

  @override
  FutureOr<void> onLoad() async {
    game = findGame();
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

class CallButton extends OKButton {
  CallButton(super.buttonPath, super.buttonPath_clicked, super.betNumber,
      super.x, super.y, super.w, super.h, super.scale, super.isPressed,
      {required super.priority});
  @override
  void onTapUp(TapUpEvent event) async {
    game.player.bet = game.player.lastBet;
    // print("call button: "+ game.player.bet.toString());
    await game.socket.emit("get-turn", {
      "roomCode": game.player.roomId,
      "reset": false,
      "userBetNumber": game.player.bet
    });
    world.curBalance.text = game.player.cash.toString();
  }
}

class AllInButton extends OKButton {
  AllInButton(super.buttonPath, super.buttonPath_clicked, super.betNumber,
      super.x, super.y, super.w, super.h, super.scale, super.isPressed,
      {required super.priority});
  @override
  void onTapUp(TapUpEvent event) async {
    game.player.bet = game.player.cash;
    game.player.cash = 0.0;

    await game.socket.emit("get-turn", {
      "roomCode": game.player.roomId,
      "reset": false,
      "userBetNumber": game.player.bet,
      "allIn": true,
      "minBet": game.player.bet
    });
    // super.onTapUp(event);
    world.curBalance.text = game.player.cash.toString();
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

class FoldButton extends Button {
  // ignore: non_constant_identifier_names
  late String buttonPath_clicked;
  FoldButton(super.buttonPath, this.buttonPath_clicked, super.x, super.y,
      super.w, super.h, super.scale,
      {required super.priority});

  @override
  void onTapUp(TapUpEvent event) async {
    // game.socket.cash = 0;
    await game.socket.emit("fold", {"roomCode": game.player.roomId});
    super.onTapUp(event);
  }
}
