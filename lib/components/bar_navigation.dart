import 'dart:async';

import 'package:flame/components.dart';
import 'package:poker_flutter_game/components/button.dart';
import 'package:poker_flutter_game/navigations/popup.dart';

class NavBar extends PositionComponent {
  var game;
  late MenuButton barButton;
  late Popup menuPopup;
  late Button settingsButton;

  @override
  FutureOr<void> onLoad() {
    game = findGame();
    barButton = MenuButton('buttons/navigation_bar.png', (game.size.y / 10),
        (game.size.y / 10), 75, 75, game.size.y / 700,
        priority: 100);
    menuPopup = Popup('buttons/popup.png', game.size.x / 2, game.size.y / 2,
        400, 512, game.size.y / 700, 100);
    settingsButton = Button(
        'buttons/settings.png',
        (game.size.y / 10) + (game.size.y / 8),
        (game.size.y / 10),
        75,
        75,
        game.size.y / 700,
        priority: 100);
    priority = 100;
    add(barButton);
    add(settingsButton);
  }
}
