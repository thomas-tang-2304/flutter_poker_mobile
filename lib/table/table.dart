import 'dart:async';

// import 'dart:math';
import 'package:flame/text.dart';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:poker_flutter_game/components/button.dart';

import 'package:poker_flutter_game/table/buttons/call.dart';
import 'package:poker_flutter_game/table/cards/card.dart';
import 'package:poker_flutter_game/table/slider/thumb.dart';
import 'package:poker_flutter_game/table/slider/track.dart';
import 'package:poker_flutter_game/utils/text_render.dart';
import 'package:flame/effects.dart';

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
    okButtonComponent = OKButton("buttons/ok_button.png", "buttons/ok_button.png", 0.0, 80 * 16, 30 * 16, 60, 40, 3, false, priority: 2);
    allInButtonComponent = AllInButton("buttons/all_in.png", "buttons/all_in.png", 0.0, 80 * 16, 40 * 16, 60, 40, 3, false, priority: 2);
    trackComponent = Track("slider/track.png", 80 * 16, 0 * 16);
    thumbComponent = Thumb("slider/thumb.png", 80 * 16, 18.125 * 16);
    startButton = StartButton("buttons/popup_button.png", "START", 0, 0, 217, 60, 3, priority: 10);

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
  // Remove async unless you absolutely need it for await calls inside.
  // Since we remove the unnecessary awaits, the function can be synchronous.
  void update(double dt) async {
    // --- 1. Betting UI Calculation (Keep) ---
    // The value calculation is fine, but the logic should be encapsulated.
    final currentBetText = calculateNumber(
      (0 - (100 * (thumbComponent.position.y - 290) / 580)) * game.player.cash / 100
    ).toStringAsFixed(0);
    renderText.text = '${currentBetText}K';
    
    okButtonComponent.betNumber = double.parse(currentBetText);

    final bettingComponents = [
      okButtonComponent, 
      trackComponent, 
      thumbComponent, 
      allInButtonComponent, 
      renderText
    ];

    if (betButtonComponent.betActive) {
      for (var comp in bettingComponents) {
        if (!comp.isMounted) {
          await add(comp);
        }
      }
    } else {
      for (var comp in bettingComponents) {
        if (comp.isMounted) {
          remove(comp);
        }
      }
    }

    final actionComponents = [
      callButtonComponent, 
      betButtonComponent, 
      foldButtonComponent, 
      lastBetText
    ];

    if (game.player.isPlayersTurn && game.player.hasStartedGame) {
      for (var comp in actionComponents) {
        if (!comp.isMounted) {
          add(comp);
        }
      }
    } else {
      // Check if any component is mounted before attempting removal.
      // If you need the whole block removed, it's safer to check one component.
      if (callButtonComponent.isMounted) { 
        for (var comp in actionComponents) {
          if (comp.isMounted) {
            remove(comp);
          }
        }
      }
    }

    lastBetText.text = game.player.lastBet == 0.0
        ? ""
        : game.player.lastBet.toString();

    final usersList = game.player.swappedUsersList;
    final cardsList = game.player.playerCardsDisplay;

    if (usersList.isNotEmpty && cardsList.isNotEmpty) {
      int indexOfPlayerTurn = usersList.indexWhere(
        (value) => value["username"] == game.player.playerNameTurn
      );

      double activeOpacity = 1.0;
      double inactiveOpacity = 0.4;

      for (var i = 0; i < cardsList.length; i++) {
        final playerInGame = cardsList[i];
        final targetOpacity = (i == indexOfPlayerTurn) ? activeOpacity : inactiveOpacity;

        if (i == 0) {
          for (var cardInGame in playerInGame) {
            if (cardInGame?.button.opacity != targetOpacity) {
              cardInGame?.button.opacity = targetOpacity;
            }
          }
        } else {
         
          if (playerInGame?.button.opacity != targetOpacity) {
            playerInGame?.button.opacity = targetOpacity;
          }
        }
      }
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
    
      dynamic swappedUsersList = dividedCardsResult?['users'];

      var indexOfPlayer = (swappedUsersList?.indexWhere((value) {
        return (value["username"] == game.player.name);
      }));
      var temp = swappedUsersList[0];
      swappedUsersList[0] = swappedUsersList[indexOfPlayer];
      swappedUsersList[indexOfPlayer] = temp;

      List<dynamic> animationCardOrder = [];
      // print(divided_cards_result);

      for (var initPos = -30; initPos <= 30; initPos += 15) {
        animationCardOrder.add(
          addRegularCard("deck/flip_down.png", initPos.toString(), "0", 0.0, 1.0, 1.3, 40.0, 60.0)
        );
      }
      if (startButton.isMounted) {
        super.remove(startButton);
        game.player.isPlayersTurn = true;
      }
      // print("swappedUsersList");
      // print(swappedUsersList);
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
            String moveToX = (cardPosPlayers[dividedCardsResult?['users'].length - 2]
                        ['player$i']?['x'][x])
                    .toString();
            String moveToY = (cardPosPlayers[dividedCardsResult?['users'].length - 2]
                        ['player$i']?['y'])
                    .toString();
            
            final handCard = addRegularCard(
                "deck/$c2.png",
                moveToX,
                moveToY,
                0.0,
                1.0,
                1.0, 
                40.0,
                60.0);
            mainPlayerCard.add(handCard["cardComponent"]); 
            animationCardOrder.add(handCard);
            x++;
          });
         
          game.player.playerCardsDisplay.add(mainPlayerCard);
        } else {
         
            final handCard = addRegularCard(
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
              1.0,
              75.0,
              75.0
            );
            game.player.playerCardsDisplay.add(handCard["cardComponent"]);
            animationCardOrder.add(handCard);
              
        }

        i++;
      });
      
      Future.forEach(animationCardOrder, (dynamic cardObject) async {
        final cardComponent = cardObject["cardComponent"] as Card;
          final cardAnimation = cardObject["animation"] as Future;
          await Future.delayed(const Duration(milliseconds: 250));
          await cardAnimation.then((value) async {

            await add(cardComponent);
            await cardComponent.add(value);
          });
      });
      game.player.hasStartedGame = true;
     
    });

    await game.socket.on("handle-bet", (handleBetResult) async {
      print(handleBetResult);
      List<Card> animationCardOrder = [];

      // removeAll(children.whereType<Card>().where((child) => child.position.y == 0 && child.isMounted));
      if (handleBetResult["message"] != "Hand Ranking successfully") {
        
        List<dynamic> filpUpCard = handleBetResult?["data"]?["flipUp"];
        int flipDownStartIndex = 5 - children.whereType<Card>().where((child) => child.position.y == 0.0 && child.isMounted && child.buttonPath == "deck/flip_down.png").length;

        children.whereType<Card>().where((child) => child.position.y == 0.0 && child.isMounted && child.buttonPath =="deck/flip_down.png").forEach((card) {
          if (flipDownStartIndex < filpUpCard.length){
            card.buttonPath = "deck/${filpUpCard[flipDownStartIndex]}.png";
            flipDownStartIndex++;
          }
          // card.position.y = 0.0;
          // card.position.x = initPos * 16.0;
          animationCardOrder.add(card);
          
        });
        await Future.forEach(animationCardOrder, (Card cardComponent) async {
          final double originScaleX = cardComponent.scale.x;
          final String originPath = cardComponent.buttonPath;

          // Only run flip effects once originPath is not a flip_down card
          if (originPath != "deck/flip_down.png"){
            // Flip down effect 
            final flipDownEffect = ScaleEffect.to(
              Vector2(0, cardComponent.scale.y),
              EffectController(duration: 0.5),
            );
            flipDownEffect.onComplete = () async {
              cardComponent.scale.x = 0;
              cardComponent.button.sprite = await Sprite.load(originPath);
            };

            // Flip up effect
            final flipUpEffect = ScaleEffect.to(
              Vector2(originScaleX, cardComponent.scale.y),
              EffectController(duration: 0.5),
            );
            flipUpEffect.onComplete = () {
              cardComponent.scale.x = originScaleX;
            };


            await Future.delayed(const Duration(milliseconds: 250));
            await add(cardComponent);
            await cardComponent.add(flipDownEffect);
            await Future.delayed(const Duration(milliseconds: 500));
            await cardComponent.add(flipUpEffect);
          }
        });
        game.player.lastBet = 0.0;
      } else {
        // Handle events to end this match
        game.player.swappedUsersList = [];
        game.player.hasStartedGame = false;
        game.player.isPlayersTurn = false;
        game.player.cash = 0.0;
        game.socket.off('divided');
        game.socket.off('handle-bet');
      }
      game.player.roomBet = 0.0;
      game.player.turnCount = 0;
    });
  }
  // add 2 cards at the individual position of players function
  Map<String, dynamic> addRegularCard(String cardPath,String x, String y, double angle, double opacity, double _scale, double w, double h) {
    var _card = Card(cardPath, 0 * 16, 0 * 16,
        w * 4, h * 4, angle, opacity, _scale,
        priority: 2);
    _card.position.x = 0;
    _card.position.y = -40*16;
    _card.anchor = Anchor.center;
    final Vector2 targetPosition = Vector2(double.parse(x) * 16, double.parse(y) * 16);
    final moveEffect = MoveEffect.to(
        targetPosition,
        EffectController(duration: 0.5), // Duration of 0.3 seconds
    );

    moveEffect.onComplete = () {
      
      _card.position.x = double.parse(x) * 16; 
      _card.position.y = double.parse(y) * 16; 
    };
    
    
    final animationFuture = Future<dynamic>.delayed(const Duration(milliseconds: 500), () async {
      
      return moveEffect;
    });
    return {
      "cardComponent": _card,
      "animation": animationFuture
    };
  }


  
  @override
  void onRemove() {
    game.player.swappedUsersList = [];
    game.player.hasStartedGame = false;
    game.player.isPlayersTurn = false;
    game.player.cash = 0.0;
    game.socket.off('divided');
    game.socket.off('handle-bet');
    removeAll(children.where((child) => child.isMounted));
  }
}
