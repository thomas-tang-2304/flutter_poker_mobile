// import 'dart:async';

// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/text.dart';
// import 'package:poker_flutter_game/components/menu_popup.dart';
// import 'package:poker_flutter_game/utils/text_render.dart';

// class CreateRoomPopup extends PositionComponent with TapCallbacks {
//   var game;
//   late String buttonPath;
//   late double x;
//   late double y;
//   late double w;
//   late double h;
//   late final double _scale;

//   late PopupButtonWithText quitButton = PopupButtonWithText(
//       "Quit",
//       'buttons/popup_button_3.png',
//       game.size.x / 2,
//       game.size.y / 2,
//       217,
//       60,
//       game.size.y / 700);

//   late CloseButton closeButton = CloseButton(
//       'buttons/close_button.png',
//       game.size.x / 2,
//       game.size.y / 2 + game.size.y / 2.8,
//       75,
//       75,
//       game.size.y / 700,
//       priority: 1);

//   late TextComponent<TextRenderer> renderText = TextComponent(
//     text: "TITLE",
//     anchor: Anchor.center,
//     position: Vector2(game.size.x / 2, game.size.y / 2 - game.size.y / 3.2),
//     textRenderer: regular,
//   );

//   // ignore: unused_field, prefer_typing_uninitialized_variables
//   var _rect;

//   @override
//   bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());

//   // Generative Constructor
//   // ignore: non_constant_identifier_names
//   Popup(this.buttonPath, this.x, this.y, this.w, this.h, this._scale,
//       int priority) {
//     this.priority = priority;
//     _rect = Rect.fromLTWH(
//         x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
//   }

//   SpriteComponent button = SpriteComponent();

//   @override
//   FutureOr<void> onLoad() async {
//     game = findGame();
//     button
//       ..sprite = await Sprite.load(buttonPath)
//       ..size = Vector2(w * _scale, h * _scale)
//       ..x = x
//       ..y = y
//       ..anchor = Anchor.center;
//     await add(button);
//     await add(closeButton);
//     await add(renderText);
//     await add(quitButton);

//     return super.onLoad();
//   }
// }
