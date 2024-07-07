import 'dart:async';

import 'package:flame/components.dart';
// import 'package:poker_flutter_game/home/home.dart';
import 'package:poker_flutter_game/table/table.dart';

class Poker extends Component {
  late CameraComponent cam;
  var game;
  final world = PokerTable();


  @override
  FutureOr<void> onLoad() {
    game = findGame();
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 220 * 16,
      height: (game.size.y * 220 * 16) / game.size.x,
    );
    cam.viewfinder.anchor = Anchor.center;
    add(cam);
    add(world);
  }
}
