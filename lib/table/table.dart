import 'dart:async';

// import 'dart:math';
import 'package:flame/text.dart';

import 'package:flame/components.dart';
import 'package:poker_flutter_game/components/button.dart';

import 'package:poker_flutter_game/table/buttons/call.dart';
import 'package:poker_flutter_game/table/cards/card.dart';
import 'package:poker_flutter_game/table/slider/thumb.dart';
import 'package:poker_flutter_game/table/slider/track.dart';
import 'package:poker_flutter_game/utils/text_render.dart';

class PokerTable extends World {
  // final gameplayAPI = GameplayAPI();
  final List<Map<String, Map<String, dynamic>>> cardPosPlayers = [
    {
      "player1": {
        "x": [-20, -10],
        "y": 20
      },
      "player2": {
        "x": [8, 18],
        "y": -20
      },
    },
    {
      "player1": {
        "x": [-5, 5],
        "y": 20
      },
      "player2": {
        "x": [-50, -40],
        "y": -20
      },
      "player3": {
        "x": [40, 50],
        "y": -20
      },
    },
    {
      "player1": {
        "x": [-5, 5],
        "y": 20
      },
      "player2": {
        "x": [-76, -66],
        "y": 0
      },
      "player3": {
        "x": [-5, 5],
        "y": -20
      },
      "player4": {
        "x": [66, 76],
        "y": 0
      },
    },
    {
      "player1": {
        "x": [-5, 5],
        "y": 20
      },
      "player2": {
        "x": [-76, -66],
        "y": 0
      },
      "player3": {
        "x": [-50, -40],
        "y": -20
      },
      "player4": {
        "x": [40, 50],
        "y": -20
      },
      "player5": {
        "x": [66, 76],
        "y": 0
      },
    },
    {
      "player1": {
        "x": [40, 50],
        "y": 20
      },
      "player2": {
        "x": [-50, -40],
        "y": 20
      },
      "player3": {
        "x": [-76, -66],
        "y": 0
      },
      "player4": {
        "x": [-50, -40],
        "y": -20
      },
      "player5": {
        "x": [40, 50],
        "y": -20
      },
      "player6": {
        "x": [66, 76],
        "y": 0
      },
    }
  ];
  // ignore: non_constant_identifier_names

  late SpriteComponent pokerTable = SpriteComponent();
  late CallButton callButtonComponent;
  late BetButton betButtonComponent;
  late FoldButton foldButtonComponent;
  late OKButton okButtonComponent;
  late OKButton allInButtonComponent;
  late StartButton startButton;
  late Track trackComponent;
  late Thumb thumbComponent;

  var game;

  late TextComponent<TextRenderer> renderText;
  late TextComponent<TextRenderer> curBalance;
  late TextComponent<TextRenderer> lastBetText;

  @override
  FutureOr<void> onLoad() async {
    game = findGame();
    pokerTable
      ..sprite = await Sprite.load('table_2.png')
      ..width = 200 * 16
      ..height = 100 * 16
      ..x = 0
      ..y = 0
      ..anchor = Anchor.center;
    betButtonComponent = BetButton("buttons/bet_button.png",
        "buttons/bet_button_clicked.png", 0 * 16, 40 * 16, 90, 30, 4, false,
        priority: 2);
    callButtonComponent = CallButton(
        "buttons/call_button.png",
        "buttons/call_button_clicked.png",
        0.0,
        -24 * 16,
        40 * 16,
        90,
        30,
        4,
        false,
        priority: 2);
    foldButtonComponent = FoldButton(
      "buttons/fold_button.png",
      "buttons/fold_button_clicked.png",
      24 * 16,
      40 * 16,
      90,
      30,
      4,
      priority: 2,
    );
    okButtonComponent = OKButton("buttons/ok_button.png",
        "buttons/ok_button.png", 0.0, 80 * 16, 30 * 16, 60, 40, 3, false,
        priority: 2);
    allInButtonComponent = AllInButton("buttons/all_in.png", "buttons/all_in.png",
        0.0, 80 * 16, 40 * 16, 60, 40, 3, false,
        priority: 2);
    trackComponent = Track("slider/track.png", 80 * 16, 0 * 16);
    thumbComponent = Thumb("slider/thumb.png", 80 * 16, 18.125 * 16);
    startButton = StartButton(
        "buttons/popup_button.png", "START", 0, 0, 217, 60, 3,
        priority: 10);

    thumbComponent.position[0] = 80 * 16;
    thumbComponent.position[1] = 18.125 * 16;

    renderText = TextComponent(
      scale: Vector2.all(3.5),
      text: thumbComponent.position[1].toString(),
      anchor: Anchor.center,
      position: Vector2(80 * 16, -30 * 16),
      textRenderer: regular,
    );

    curBalance = TextComponent(
      scale: Vector2.all(3.5),
      text: game.player.cash.toString(),
      anchor: Anchor.center,
      position: Vector2(60 * 16, -45 * 16),
      textRenderer: regular,
    );

    lastBetText = TextComponent(
      text: game.player.lastBet.toString(),
      anchor: Anchor.center,
      position: Vector2(
        -24 * 16,
        45 * 16,
      ),
      textRenderer: roomCodeRegular,
    );
    // print(pokerTable);

    add(pokerTable);

    // render cards on table
    divideCards();

    // function buttons (call, check, bet, fold,...) position at {124*16, 75*16}
    add(callButtonComponent);
    add(betButtonComponent);
    add(foldButtonComponent);
    add(curBalance);
    add(lastBetText);
    add(allInButtonComponent);
  }

  double calculateNumber(double number) {
    double a = number % 1000;

    if (a > 0) {
      return (number ~/ 1000) * 1000 + 1000;
    }

    return number;
  }

  @override
  void update(double dt) async {
    renderText.text =
        '${calculateNumber((0 - (100 * (thumbComponent.position[1] - 290) / 580)) * game.player.cash / 100).toStringAsFixed(0)}K';

    okButtonComponent.betNumber =
        double.parse(renderText.text.substring(0, renderText.text.length - 1));

    if (!betButtonComponent.betActive) {
      if (trackComponent.isMounted) {
        remove(thumbComponent);
        remove(okButtonComponent);
        remove(trackComponent);
        remove(allInButtonComponent);
        remove(renderText);
      }
    } else {
      add(trackComponent);
      add(thumbComponent);
      add(okButtonComponent);
      add(allInButtonComponent);
      add(renderText);
    }
    if (game.player.isPlayersTurn && game.player.hasStartedGame) {
      add(callButtonComponent);
      add(betButtonComponent);
      add(foldButtonComponent);
      add(lastBetText);
    } else {
      if (callButtonComponent.isMounted) {
        remove(callButtonComponent);
        remove(betButtonComponent);
        remove(foldButtonComponent);
        remove(lastBetText);
      }
    }

    if (game.player.lastBet == 0.0) {
      lastBetText.text = "";
    } else {
      lastBetText.text = game.player.lastBet.toString();
    }

    // select the player's turn, whose turn are selected the opacity was set to 1, else to 0.4
    if (game.player.swappedUsersList.length > 0 &&
        game.player.playerCardsDisplay.length > 0) {
      int indexOfPlayerTurn = game.player.swappedUsersList.indexWhere((value) {
        return value["username"] == game.player.playerNameTurn;
      });
      var i = 0;
      game.player.playerCardsDisplay.forEach((playerInGame) async {
        if (i == indexOfPlayerTurn) {
          if (i == 0) {
            playerInGame.forEach((cardInGame) async {
              cardInGame?.button.opacity = 1.0;
            });
          } else {
            playerInGame?.button.opacity = 1.0;
          }
        } else {
          if (i == 0) {
            playerInGame.forEach((cardInGame) async {
              cardInGame?.button.opacity = 0.4;
            });
          } else {
            playerInGame?.button.opacity = 0.4;
          }
        }
        // print(i);

        i++;
      });
    }

    super.update(dt);
  }

  void divideCards() async {
    await game.socket.on('joined', (joinedResult) {
      game.player.roomBet = 0.0;
      game.player.swappedUsersList = [];
      if (joinedResult?["data"]?["room"]?["host"]?["username"] ==
          game.player.name) {
        super.add(startButton);
      }
    });

    await game.socket.on('leaved', (leavedResult) {
      game.player.roomBet = 0.0;
      game.player.swappedUsersList = [];
      if (leavedResult?["data"]?["host"]?["username"] == game.player.name) {
        super.add(startButton);
      }
    });

    await game.socket.on("divided", (dynamic dividedCardsResult) {
      game.player.hasStartedGame = true;

      dynamic swappedUsersList = dividedCardsResult?['users'];
      // print(dividedCardsResult);

      var indexOfPlayer = (swappedUsersList?.indexWhere((value) {
        return (value["username"] == game.player.name);
      }));
      var temp = swappedUsersList[0];
      swappedUsersList[0] = swappedUsersList[indexOfPlayer];
      swappedUsersList[indexOfPlayer] = temp;

      // print(divided_cards_result);

      for (var initPos = -30; initPos <= 30; initPos += 15) {
        addCard("deck/flip_down.png", initPos.toString(), "0", 0.0, 1.0, 1.3);
      }
      if (startButton.isMounted) {
        super.remove(startButton);
        game.player.isPlayersTurn = true;
      }
      print(swappedUsersList);
      game.player.swappedUsersList = swappedUsersList;
      game.player.playerNameTurn =
          dividedCardsResult['usersTurn'][0]["username"];
      game.player.playerCardsDisplay = [];
      var i = 1;

      swappedUsersList.forEach((c) {
        var x = 0;

        if (i == 1) {
          var mainPlayerCard = [];
          dividedCardsResult?['userCards'][c["username"]].forEach((c2) {
            mainPlayerCard.add(addCard(
                "deck/$c2.png",
                (cardPosPlayers[dividedCardsResult?['users'].length - 2]
                        ['player$i']?['x'][x])
                    .toString(),
                (cardPosPlayers[dividedCardsResult?['users'].length - 2]
                        ['player$i']?['y'])
                    .toString(),
                0.0,
                1.0,
                1.0));
            x++;
          });
          game.player.playerCardsDisplay.add(mainPlayerCard);
        } else {
          game.player.playerCardsDisplay.add(addCard2(
              "deck/double_flip_down.png",
              ((cardPosPlayers[dividedCardsResult?['users'].length - 2]
                          ['player$i']?['x'][0]) +
                      5)
                  .toString(),
              (cardPosPlayers[dividedCardsResult?['users'].length - 2]
                      ['player$i']?['y'])
                  .toString(),
              0.0,
              1.0,
              1.0));
        }

        i++;
      });
    });

    await game.socket.on("handle-bet", (handleBetResult) {
      // print(handleBetResult);

      if (handleBetResult["message"] != "Hand Ranking successfully") {
        var initPos = -30;
        handleBetResult?["data"]?["flipUp"]?.forEach((card) {
          addCard("deck/$card.png", initPos.toString(), "0", 0.0, 1.0, 1.3);

          initPos += 15;
        });
        game.player.lastBet = 0.0;
      } else {
        // Handle events to end this match
        game.player.swappedUsersList = [];
        game.player.hasStartedGame = false;
        game.player.isPlayersTurn = false;
        game.player.cash = 0.0;
      }
      game.player.roomBet = 0.0;
      game.player.turnCount = 0;
    });
  }

  Card addCard(cardPath, x, y, angle, opacity, _scale) {
    // var x = c[1] as double;
    var _card = Card(cardPath, double.parse(x) * 16, double.parse(y) * 16,
        40 * 4, 60 * 4, angle, opacity, _scale,
        priority: 2);
    _card.position.x = double.parse(x);
    _card.position.y = double.parse(y);
    _card.anchor = Anchor.center;
    add(_card);
    return _card;
  }

  Card addCard2(cardPath, x, y, angle, opacity, _scale) {
    // var x = c[1] as double;
    var _card = Card(cardPath, double.parse(x) * 16, double.parse(y) * 16,
        75 * 4, 75 * 4, angle, opacity, _scale,
        priority: 2);
    _card.position.x = double.parse(x);
    _card.position.y = double.parse(y);
    _card.anchor = Anchor.center;
    add(_card);
    return _card;
  }
}
