import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:poker_flutter_game/lobby/lobby.dart';
import 'package:poker_flutter_game/utils/paging.dart';
import 'package:poker_flutter_game/utils/text_render.dart';

class Button extends PositionComponent with TapCallbacks {
  late String buttonPath;
  late double x;
  late double y;
  late double w;
  late double h;
  late double _scale;
  late int priority;
  var _rect;
  late var game;

  // Generative Constructor
  // ignore: non_constant_identifier_names
  Button(
      String buttonPath, double x, double y, double w, double h, double _scale,
      {required int priority}) {
    // ignore: prefer_initializing_formals
    this.buttonPath = buttonPath;

    // ignore: prefer_initializing_formals
    this.x = x;
    // ignore: prefer_initializing_formals
    this.y = y;

    // ignore: prefer_initializing_formals
    this.w = w;
    // ignore: prefer_initializing_formals
    this.h = h;
    // ignore: prefer_initializing_formals
    this._scale = _scale;

    // ignore: prefer_initializing_formals
    this.priority = priority;

    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }

  SpriteComponent button = SpriteComponent();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());
  @override
  void onTapUp(TapUpEvent event) async {
    button.y -= 2;
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.y += 2;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    game = findGame();
    button
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(w * _scale, h * _scale)
      ..x = x
      ..y = y
      ..anchor = Anchor.center;
    add(button);

    return super.onLoad();
  }
}

class MiniTable extends Button {
  late String roomCode;
  late int firstBet;
  late var game;
  MiniTable(super.buttonPath, this.roomCode, this.firstBet, super.x, super.y,
      super.w, super.h, super.scale,
      {required super.priority});

  late TextComponent<TextRenderer> roomCodeText = TextComponent(
    text: roomCode,
    anchor: Anchor.center,
    position: Vector2(x, y - 15 * 16),
    textRenderer: roomCodeRegular,
  );

  late TextComponent<TextRenderer> firstBetText = TextComponent(
    text: firstBet % 1000 == 0
        ? "${(firstBet / 1000).round()}K"
        : "${(firstBet / 1000)}K",
    anchor: Anchor.center,
    position: Vector2(x + 22 * 16, y + 11 * 16),
    textRenderer: firstBetRegular,
  );

  late List<Button> userActive = [];
  SpriteComponent button = SpriteComponent();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());
  @override
  void onTapUp(TapUpEvent event) async {
    button.y -= 2;
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.y += 2;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    game = findGame();
    button
      ..sprite = await Sprite.load(buttonPath)
      ..size = Vector2(w * _scale, h * _scale)
      ..x = x
      ..y = y
      ..anchor = Anchor.center;
    add(button);
    add(roomCodeText);
    add(firstBetText);

    var _x = -7 ;
    var _y = -3;
    for (var i = 0; i < 6; i++) {
      userActive.add(Button(
          "icons/vecteezy_alpaca-face-icon-cute-animal-icon-in-circle_20647519.png",
          x + _x * 16,
          y + _y * 16,
          5 * 16,
          5 * 16,
          1,
          priority: 5));
      if (i == 2) {
        _y += 6;
        _x = -7;
      } else {
        _x += 7;
      }
    }
    addAll(userActive);
    return super.onLoad();
  }
}

class LeftArrow extends Button with HasWorldReference<Lobby> {
  LeftArrow(super.buttonPath, super.x, super.y, super.w, super.h, super.scale,
      {required super.priority});

  @override
  void onTapUp(TapUpEvent event) {
    world.scrollLobby.page--;
    if (world.scrollLobby.page >= 1) {
      world.scrollLobby
          .removeAll(world.scrollLobby.children.query<MiniTable>());

      world.scrollLobby.paginateText.text =
          '${(world.scrollLobby.page - 1) * world.scrollLobby.limit + 1} - ${(world.scrollLobby.page) * world.scrollLobby.limit}';

      int i = 1;
      if (world.scrollLobby.full_tables != null) {
        world.scrollLobby.tables = world.scrollLobby.full_tables?.sublist(
            ((world.scrollLobby.page - 1) * world.scrollLobby.limit),
            ((world.scrollLobby.page) * world.scrollLobby.limit) >
                    world.scrollLobby.full_tables.length
                ? world.scrollLobby.full_tables.length
                : (world.scrollLobby.page) * world.scrollLobby.limit);

        for (final table in world.scrollLobby.tables) {
          MiniTable room_sprite = MiniTable(
              'mini_table.png',
              table["roomCode"],
              table["firstBet"],
              world.scrollLobby.initialTable_X,
              world.scrollLobby.initialTable_Y,
              700,
              350,
              1,
              priority: 5);
          world.scrollLobby.add(room_sprite);
          world.scrollLobby.initialTable_X += world.scrollLobby.gap_x;
          // countRoom += 1;
          // print(countRoom);
          if (i % 3 == 0) {
            world.scrollLobby.initialTable_Y += world.scrollLobby.gap_y;
            world.scrollLobby.initialTable_X = -60 * 16;
          }
          i++;
        }
      }
      world.scrollLobby.initialTable_X = -60 * 16;
      world.scrollLobby.initialTable_Y = -300;

      button.y += 2;
    } else {
      world.scrollLobby.page++;
    }

    super.onTapUp(event);
  }
}

class RightArrow extends Button with HasWorldReference<Lobby> {
  RightArrow(super.buttonPath, super.x, super.y, super.w, super.h, super.scale,
      {required super.priority});

  @override
  void onTapUp(TapUpEvent event) {
    world.scrollLobby.page++;
    if (pageOfTables(
            world.scrollLobby.full_tables?.length, world.scrollLobby.limit) >=
        world.scrollLobby.page) {
      world.scrollLobby
          .removeAll(world.scrollLobby.children.query<MiniTable>());

      world.scrollLobby.paginateText.text =
          '${(world.scrollLobby.page - 1) * world.scrollLobby.limit + 1} - ${(world.scrollLobby.page) * world.scrollLobby.limit}';

      int i = 1;

      if (world.scrollLobby.full_tables != null) {
        world.scrollLobby.tables = world.scrollLobby.full_tables?.sublist(
            ((world.scrollLobby.page - 1) * world.scrollLobby.limit),
            ((world.scrollLobby.page) * world.scrollLobby.limit) >
                    world.scrollLobby.full_tables.length
                ? world.scrollLobby.full_tables.length
                : (world.scrollLobby.page) * world.scrollLobby.limit);
        for (final table in world.scrollLobby.tables) {
          MiniTable room_sprite = MiniTable(
              'mini_table.png',
              table["roomCode"],
              table["firstBet"],
              world.scrollLobby.initialTable_X,
              world.scrollLobby.initialTable_Y,
              700,
              350,
              1,
              priority: 5);
          world.scrollLobby.add(room_sprite);
          world.scrollLobby.initialTable_X += world.scrollLobby.gap_x;
          // countRoom += 1;
          // print(countRoom);
          if (i % 3 == 0) {
            world.scrollLobby.initialTable_Y += world.scrollLobby.gap_y;
            world.scrollLobby.initialTable_X = -60 * 16;
          }
          i++;
        }
      }
      world.scrollLobby.initialTable_X = -60 * 16;
      world.scrollLobby.initialTable_Y = -300;

      button.y += 2;
    } else {
      world.scrollLobby.page--;
    }

    super.onTapUp(event);
  }
}
