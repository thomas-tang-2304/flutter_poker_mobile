import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:poker_flutter_game/home/home.dart';
// import 'package:poker_flutter_game/utils/background.dart';

class HomePage extends Component {
  late CameraComponent cam;
  final world = Home();
  var game;

  @override
  void onRemove() {
    removeAll(children);
    Flame.images.clearCache();
    Flame.assets.clearCache();
  }

  @override
  FutureOr<void> onLoad() {
    game = findGame();
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 220 * 16,
      height: (game.size.y * 220 * 16) / game.size.x,
    );
    cam.viewfinder.anchor = Anchor.center;
    // add(Background());
    add(cam);
    add(world);
    return super.onLoad();
  }
}
