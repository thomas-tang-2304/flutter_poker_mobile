import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:poker_flutter_game/components/button.dart';
import 'package:poker_flutter_game/utils/paging.dart';
import 'package:poker_flutter_game/utils/text_render.dart';

class ScrollLobby extends PositionComponent with DragCallbacks {
  var game;

// ignore: non_constant_identifier_names
  double initialTable_X = -65 * 16;
  // ignore: non_constant_identifier_names
  double initialTable_Y = -300;

  // ignore: non_constant_identifier_names
  double gap_y = 38 * 16;
  // ignore: non_constant_identifier_names
  double gap_x = 65 * 16;

  int page = 1;
  int limit = 6;

  int countRoom = 0;

  late dynamic full_tables = [];

  late dynamic tables;

  SpriteComponent button = SpriteComponent();

  late TextComponent<TextRenderer> paginateText = TextComponent(
    text: '1 - ${limit}',
    anchor: Anchor.center,
    position: Vector2(0, 39 * 16),
    textRenderer: pagingRegular,
  );
  late RightArrow rightArrow = RightArrow(
      "buttons/right_arrow.png", 13 * 16, 39 * 16, 15, 20, 6,
      priority: 5);
  late LeftArrow leftArrow = LeftArrow(
      "buttons/left_arrow.png", -13 * 16, 39 * 16, 15, 20, 6,
      priority: 5);

  @override
  FutureOr<void> onLoad() async {
    // ignore: unused_local_variable
    game = findGame();
    // print(jsonDecode(game.socket));
    await game.socket
        .emit('get-sample-rooms');

    await game.socket.on("sample-rooms", (handler) {
  
      if (handler["data"] != null) {
        full_tables = handler["data"];
        int i = 1;
        tables = full_tables?.sublist(
            ((page - 1) * limit),
            ((page) * limit) > full_tables.length
                ? full_tables.length
                : (page) * limit);
        for (final table in tables) {
          MiniTable roomSprite = MiniTable('mini_table.png', table,
              initialTable_X, initialTable_Y, 700, 350, 1.2,
              priority: 5);
          add(roomSprite);
          initialTable_X += gap_x;
          if (i % 3 == 0) {
            initialTable_Y += gap_y;
            initialTable_X = -65 * 16;
          }
          i++;
        }
        initialTable_X = -65 * 16;
        initialTable_Y = -300;
      }
    });
    add(paginateText);

    add(leftArrow);
    add(rightArrow);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    // print(page);
    if (page >= pageOfTables(full_tables.length, limit)) {
      rightArrow.button.opacity = 0.5;
    } else {
      rightArrow.button.opacity = 1;
    }
    if (page <= 1) {
      leftArrow.button.opacity = 0.5;
    } else {
      leftArrow.button.opacity = 1;
    }
  }
}
