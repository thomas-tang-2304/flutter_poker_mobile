import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
// import 'package:poker_flutter_game/components/bar_navigation.dart';
// import 'package:flutter/material.dart';

import 'package:poker_flutter_game/home/button.dart';
import 'package:poker_flutter_game/table/cards/card.dart';
import 'package:poker_flutter_game/table/cards/chips.dart';

class Home extends World {
  late HomeButtonWithText homeButton = HomeButtonWithText('Play as guest',
      'buttons/popup_button_wide.png', 0 * 16, 13 * 16, 150, 40, 5,
      priority: 5);

  late FBLoginButton fBLoginButton =
      FBLoginButton('buttons/facebook_login.png', -10 * 16, 30 * 16, 40, 44, 5);
  late GGLoginButton gGLoginButton =
      GGLoginButton('buttons/google_login.png', 10 * 16, 30 * 16, 40, 44, 5);

  var game;

  @override
  FutureOr<void> onLoad() async {
    game = findGame();
    await add(Card(
        "deck/diamond_jack.png", -93 * 16, 34 * 16, 40 * 5, 60 * 5, 0, 1,
        priority: priority));
    await add(Card(
        "deck/clover_ace.png", -88 * 16, 36 * 16, 40 * 5, 60 * 5, pi / 12.0, 1,
        priority: 3));

    await add(Card(
        "deck/flip_down.png", -61 * 16, 27 * 16, 40 * 5, 60 * 5, pi * 0.4, 1,
        priority: priority));
    await add(Card(
        "deck/flip_down.png", -59 * 16, 29 * 16, 40 * 5, 60 * 5, pi * 1.7, 1,
        priority: 3));

    await add(Card(
        "deck/diamond_8.png", -71 * 16, 0 * 16, 40 * 5, 60 * 5, pi / 3.4, 1,
        priority: 3));

    await add(Card(
        "deck/heart_6.png", -106 * 16, 0 * 16, 40 * 5, 60 * 5, pi * 0.6, 1,
        priority: 3));

    await add(Card(
        "deck/flip_down.png", -40 * 16, 3 * 16, 40 * 5, 60 * 5, pi / 8, 1,
        priority: 4));

    await add(Card(
        "deck/heart_king.png", -11 * 16, -44 * 16, 40 * 5, 60 * 5, pi * 1.7, 1,
        priority: 2));
    await add(Card(
        "deck/heart_3.png", 107 * 16, 41 * 16, 40 * 5, 60 * 5, pi * 1.73, 1,
        priority: 2));

    await add(Card(
        "deck/spade_4.png", 19 * 16, -25 * 16, 40 * 5, 60 * 5, pi * 2.9, 1,
        priority: 2));

    await add(Card("deck/clover_6.png", 92 * 16, -33 * 16, 40 * 5, 60 * 5, 0, 1,
        priority: priority));
    await add(Card(
        "deck/spade_queen.png", 80 * 16, -21 * 16, 40 * 5, 60 * 5, pi / 12.0, 1,
        priority: 3));

    await add(Card(
        "deck/diamond_2.png", 88 * 16, 10 * 16, 40 * 5, 60 * 5, pi * 0.5, 1,
        priority: 3));

    await add(Card("deck/diamond_ace.png", 64 * 16, -20 * 16, 40 * 5, 60 * 5,
        3 * pi / 2, 1,
        priority: 3));
    await add(Card(
        "deck/spade_king.png", 67 * 16, 27 * 16, 40 * 5, 60 * 5, 2 * pi, 1,
        priority: priority));
    await add(Card(
        "deck/flip_down.png", 65 * 16, 29 * 16, 40 * 5, 60 * 5, 3 * pi / 5, 1,
        priority: 3));
    await add(Card(
        "deck/heart_7.png", -86 * 16, -31 * 16, 40 * 5, 60 * 5, pi * 2.9, 1,
        priority: 3));
    await add(Card(
        "deck/flip_down.png", 47 * 16, 53 * 16, 40 * 5, 60 * 5, pi * 1.4, 1,
        priority: 3));

    await add(Card("deck/diamond_queen.png", -62 * 16, -49 * 16, 40 * 5, 60 * 5,
        pi * 0.8, 1,
        priority: 3));
    await add(Card(
        "deck/flip_down.png", -89 * 16, -63 * 16, 40 * 5, 60 * 5, pi * 1.6, 1,
        priority: 3));

    await add(Card(
        "deck/heart_9.png", -18 * 16, -75 * 16, 40 * 5, 60 * 5, pi * 0.8, 1,
        priority: 3));
    await add(Card(
        "deck/spade_3.png", 38 * 16, -75 * 16, 40 * 5, 60 * 5, pi * 1.47, 1,
        priority: 3));

    await add(Card(
        "deck/clover_5.png", 78 * 16, -64 * 16, 40 * 5, 60 * 5, pi * 1.9, 1,
        priority: 3));
    await add(Card(
        "deck/heart_2.png", -73 * 16, 64 * 16, 40 * 5, 60 * 5, pi * 1.1, 1,
        priority: 3));
    await add(Card(
        "deck/spade_5.png", -67 * 16, 64 * 16, 40 * 5, 60 * 5, pi * 0.5, 1,
        priority: 3));
    await add(Card(
        "deck/clover_jack.png", 29 * 16, 63 * 16, 40 * 5, 60 * 5, pi * 0.69, 1,
        priority: 3));

    await add(Card(
        "deck/clover_3.png", -29 * 16, 74 * 16, 40 * 5, 60 * 5, pi * 1.8, 1,
        priority: 3));
    await add(
        Chip.c25(24 * 16, -57 * 16, 35 * 5, 35 * 5, pi * 1.36, 1, priority: 2));

    await add(
        Chip.c5(14 * 16, 58 * 16, 35 * 5, 35 * 5, pi * 1.74, 1, priority: 2));
    await add(
        Chip.c1000(18 * 16, 60 * 16, 35 * 5, 35 * 5, pi * 0.4, 1, priority: 2));
    await add(
        Chip.c500(90 * 16, -64 * 16, 35 * 5, 35 * 5, pi * 0.3, 1, priority: 0));
    await add(
        Chip.c1(-78 * 16, -28 * 16, 35 * 5, 35 * 5, pi * 1.6, 1, priority: 2));
    await add(
        Chip.c5(-48 * 16, -28 * 16, 35 * 5, 35 * 5, pi * 3.2, 1, priority: 2));

    await add(Chip.c500(-20 * 16, -28 * 16, 35 * 5, 35 * 5, pi * 3.2, 1,
        priority: 2));

    await add(
        Chip.c100(69 * 16, 68 * 16, 35 * 5, 35 * 5, pi * 1.73, 1, priority: 4));

    await add(
        Chip.c500(74 * 16, 66 * 16, 35 * 5, 35 * 5, pi * 1.2, 1, priority: 4));
    await add(
        Chip.c10(-46 * 16, 50 * 16, 35 * 5, 35 * 5, pi * 1.56, 1, priority: 4));

    await add(
        Chip.c50(-37 * 16, 30 * 16, 35 * 5, 35 * 5, pi * 0.2, 1, priority: 4));
    await add(Chip.c50(-42 * 13, -58 * 16, 35 * 5, 35 * 5, pi * 0.78, 1,
        priority: 4));

    await add(
        Chip.c500(-83 * 16, 0 * 16, 35 * 5, 35 * 5, pi * 0.78, 1, priority: 6));

    await add(Chip.c50(-120 * 13, 60 * 16, 35 * 5, 35 * 5, pi * 1.62, 1,
        priority: 4));
    await add(
        Chip.c500(82 * 16, -4 * 16, 35 * 5, 35 * 5, pi * 1.7, 1, priority: 4));

    await add(
        Chip.c25(69 * 16, 68 * 16, 35 * 5, 35 * 5, pi * 1.73, 1, priority: 4));

    await add(
        Chip.c25(3 * 16, -5 * 16, 35 * 5, 35 * 5, pi * 3, 1, priority: 2));

    await add(
        Chip.c10(-22 * 16, 48 * 16, 35 * 5, 35 * 5, pi * 5.3, 1, priority: 2));
    await add(
        Chip.c5(-22 * 16, -10 * 16, 35 * 5, 35 * 5, 0, 1, priority: priority));

    await add(
        Chip.c25(-54 * 16, -28 * 16, 35 * 5, 35 * 5, pi / 5.0, 1, priority: 2));
    await add(Chip.c1000(-45 * 16, -4 * 16, 35 * 5, 35 * 5, pi / 3.0, 1,
        priority: 3));
    await add(
        Chip.c25(36 * 16, -30 * 16, 35 * 5, 35 * 5, pi / 2, 1, priority: 5));
    await add(
        Chip.c1(56 * 16, -42 * 16, 35 * 5, 35 * 5, pi * 1.4, 1, priority: 5));
    await add(
        Chip.c10(76 * 16, 24 * 16, 35 * 5, 35 * 5, 2 * pi + 5, 1, priority: 5));
    await add(
        Chip.c50(37 * 16, 32 * 16, 35 * 5, 35 * 5, pi * 0.5, 1, priority: 5));
    await add(
        Chip.c500(37 * 16, 0 * 16, 35 * 5, 35 * 5, pi * 0.4, 1, priority: 5));
    await add(
        Chip.c5(41 * 16, 5 * 16, 35 * 5, 35 * 5, 2 * pi + 5, 1, priority: 5));
    await add(
        Chip.c100(64 * 16, 2 * 16, 35 * 5, 35 * 5, pi * 1.9, 1, priority: 5));
    await add(fBLoginButton);
    await add(gGLoginButton);
    await add(homeButton);
    return super.onLoad();
  }
}
