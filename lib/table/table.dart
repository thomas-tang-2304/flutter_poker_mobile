import 'dart:async';
import 'package:flame/text.dart';

import 'package:flame/components.dart';
import 'package:poker_flutter_game/components/button.dart';
import 'package:poker_flutter_game/apis/gameplay.dart';
import 'package:poker_flutter_game/table/buttons/call.dart';
import 'package:poker_flutter_game/table/cards/card.dart';
import 'package:poker_flutter_game/table/slider/thumb.dart';
import 'package:poker_flutter_game/table/slider/track.dart';
import 'package:poker_flutter_game/utils/text_render.dart';

class PokerTable extends World {
  final gameplayAPI = GameplayAPI();
  late SpriteComponent pokerTable = SpriteComponent();
  late BetButton betButtonComponent;
  late OKButton okButtonComponent;
  late Track trackComponent;
  late Thumb thumbComponent;
  var game;

  late TextComponent<TextRenderer> renderText = TextComponent(
    scale: Vector2.all(3.5),
    text: thumbComponent.position[1].toString(),
    anchor: Anchor.center,
    position: Vector2(100 * 16, -30 * 16),
    textRenderer: regular,
  );

  final users = ["hong", "nga", "Khoi", "nhi", "thuy", 'nghia'];

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
        "buttons/bet_button_clicked.png", 24 * 16, 35 * 16, 90, 30, 3, false,
        priority: 2);
    okButtonComponent = OKButton("buttons/ok_button.png",
        "buttons/ok_button.png", 80 * 16, 30 * 16, 60, 40, 3, false,
        priority: 2);
    trackComponent = Track("slider/track.png", 80 * 16, 0 * 16);
    thumbComponent = Thumb("slider/thumb.png", 80 * 16, 18.125 * 16);
    // print(pokerTable);
    add(pokerTable);

    // render cards on table
    divideCards();

    // function buttons (call, check, bet, fold,...) position at {124*16, 75*16}
    add(Button(
        "buttons/call_button.png",
        // "buttons/call_button_clicked.png",
        4 * 16,
        35 * 16,
        90,
        30,
        3,
        priority: 2));
    add(betButtonComponent);
    add(Button(
      "buttons/fold_button.png",
      // "buttons/fold_button_clicked.png",
      44 * 16,
      35 * 16,
      90,
      30,
      3, priority: 2,
    ));

    // print(super.priority);
  }

  @override
  void update(double dt) {
    renderText.text =
        '${(0 - (100 * (thumbComponent.position[1] - 290) / 580)).toStringAsFixed(1)}K';
    if (!betButtonComponent.betActive) {
      if (trackComponent.isMounted) {
        trackComponent.remove(thumbComponent);
        trackComponent.remove(okButtonComponent);
        super.remove(trackComponent);
      }
    } else {
      super.add(trackComponent);
      trackComponent.add(thumbComponent);
      trackComponent.add(okButtonComponent);

      trackComponent.add(renderText);
    }
    
    super.update(dt);
  }

  void divideCards() async {
    final Map<String, Map<String, dynamic>> cardPosPlayers = {
      "player1": {
        "x": [-30, -20],
        "y": 20
      },
      "player2": {
        "x": [-56, -46],
        "y": 0
      },
      "player3": {
        "x": [-30, -20],
        "y": -20
      },
      "player4": {
        "x": [18, 28],
        "y": -20
      },
      "player5": {
        "x": [44, 54],
        "y": 0
      },
      "player6": {
        "x": [18, 28],
        "y": 20
      }
    };

    // ignore: prefer_typing_uninitialized_variables
    var roomCards;

    await gameplayAPI.fetchGamePlay(users).then((value) {
      roomCards = value['roomCards'];
    });

    var i = 1;
    roomCards?['users'].forEach((c) {
      var x = 0;
      roomCards['userCards'][c].forEach((c2) {
        addCard("deck/$c2.png", cardPosPlayers['player$i']?['x'][x].toString(),
            cardPosPlayers['player$i']?['y'].toString());
        x++;
      });
      i++;
    });

    var initPos = -20;
    roomCards?["flipDown"].forEach((card) {
      // if (initPos > 100) {
      //   addCard("deck/flip_down.png", initPos.toString(), "40");
      // } else {
      addCard("deck/$card.png", initPos.toString(), "0");
      // }
      initPos += 10;
    });

    await gameplayAPI.checkHandRanking("1234").then((value) {
      print(value);
    });
  }

  void addCard(cardPath, x, y) {
    // var x = c[1] as double;

    add(Card(cardPath, double.parse(x) * 16, double.parse(y) * 16, 40 * 4,
        60 * 4, 0, 1,
        priority: 2));
  }
}
