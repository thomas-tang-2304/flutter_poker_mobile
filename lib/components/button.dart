import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:poker_flutter_game/components/menu_popup.dart';
import 'package:poker_flutter_game/lobby/lobby.dart';
import 'package:poker_flutter_game/table/index.dart';
import 'package:poker_flutter_game/table/table.dart';
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
  late dynamic table;
  late var game;
  MiniTable(super.buttonPath, this.table, super.x, super.y, super.w, super.h,
      super.scale,
      {required super.priority});

  late TextComponent<TextRenderer> roomCodeText = TextComponent(
    text: table["roomCode"],
    anchor: Anchor.center,
    position: Vector2(x, y - 17 * 16),
    textRenderer: roomCodeRegular,
  );

  late TextComponent<TextRenderer> firstBetText = TextComponent(
    text: table["firstBet"] % 1000 == 0
        ? "${(table["firstBet"] / 1000).round()}K"
        : "${(table["firstBet"] / 1000)}K",
    anchor: Anchor.center,
    position: Vector2(x, y + 5 * 16),
    priority: 10,
    textRenderer: firstBetRegular,
  );

  late List<Button> userActive = [];
  SpriteComponent button = SpriteComponent();

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());
  @override
  void onTapUp(TapUpEvent event) async {
    button.y -= 2;
    await game.socket.emit('join', {
      "username": game.player.name,
      "roomCode": table["roomCode"],
      "gameBalance": 100000
    });
    game.player.roomId = table["roomCode"];
    await game.router.pop();
    await game.router.pushRoute(Route(Poker.new));
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.y += 2;
  }

  void render(Canvas canvas) async {
    super.render(canvas);
    _rect = Rect.fromLTWH(x - 350, y - 300, 700, 350);

    final Path path = Path()..addRect(_rect);

    canvas.drawShadow(path, Color.fromARGB(64, 244, 244, 244), 40, false);
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

    var _x = [
      [0],
      [-3, 3],
      [-6, 0, 6],
      [-9, -3, 3, 9],
      [-12, -6, 0, 6, 12],
      [-15, -9, -3, 3, 9, 15]
    ];
    for (var i = 0; i < table["limit"]; i++) {
      Button userComponent = Button("user_gray.png",
          x + _x[table["limit"] - 1][i] * 16, y - 1 * 16, 3 * 16, 4 * 16, 1.2,
          priority: 5);
      userComponent.button.opacity = 0.5;
      if (table["usersCount"] - 1 >= i) {
        userComponent = Button("user_yellow.png",
            x + _x[table["limit"] - 1][i] * 16, y - 1 * 16, 3 * 16, 4 * 16, 1.2,
            priority: 5);
        userComponent.button.opacity = 1;
      }

      userActive.add(userComponent);
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
              table,
              world.scrollLobby.initialTable_X,
              world.scrollLobby.initialTable_Y,
              700,
              350,
              1.2,
              priority: 5);
          world.scrollLobby.add(room_sprite);
          world.scrollLobby.initialTable_X += world.scrollLobby.gap_x;
          // countRoom += 1;
          // print(countRoom);
          if (i % 3 == 0) {
            world.scrollLobby.initialTable_Y += world.scrollLobby.gap_y;
            world.scrollLobby.initialTable_X = -65 * 16;
          }
          i++;
        }
      }
      world.scrollLobby.initialTable_X = -65 * 16;
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
              table,
              world.scrollLobby.initialTable_X,
              world.scrollLobby.initialTable_Y,
              700,
              350,
              1.2,
              priority: 5);
          world.scrollLobby.add(room_sprite);
          world.scrollLobby.initialTable_X += world.scrollLobby.gap_x;
          // countRoom += 1;
          // print(countRoom);
          if (i % 3 == 0) {
            world.scrollLobby.initialTable_Y += world.scrollLobby.gap_y;
            world.scrollLobby.initialTable_X = -65 * 16;
          }
          i++;
        }
      }
      world.scrollLobby.initialTable_X = -65 * 16;
      world.scrollLobby.initialTable_Y = -300;

      button.y += 2;
    } else {
      world.scrollLobby.page--;
    }

    super.onTapUp(event);
  }
}

class CreateRoomButton extends Button {
  late Popup menuPopup;
  CreateRoomButton(
      super.buttonPath, super.x, super.y, super.w, super.h, super.scale,
      {required super.priority});

  late TextComponent<TextRenderer> createText = TextComponent(
      text: "Create",
      anchor: Anchor.center,
      position: Vector2(x, y),
      textRenderer: home_button_regular,
      priority: priority + 1);

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    game.overlays.add("roomCodePopup");
    super.onTapDown(event);
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(super.button);
    add(createText);
    return super.onLoad();
  }
}

class StartButton extends Button with HasWorldReference<PokerTable> {
  late String buttonText;

  StartButton(super.buttonPath, this.buttonText, super.x, super.y, super.w,
      super.h, super.scale,
      {required super.priority});

  late TextComponent<TextRenderer> startText = TextComponent(
      text: buttonText,
      anchor: Anchor.center,
      position: Vector2(x, y),
      textRenderer: home_button_regular,
      priority: priority + 1);

  @override
  void onTapDown(TapDownEvent event) async {
    // TODO: implement onTapDown
    await game.socket.emit("divide-cards", {"roomCode": game.player.roomId});
    // await game.socket.on("divided", (divided_cards_result) {
    //   world.divided_cards_result = divided_cards_result;
    // });
    super.onTapDown(event);
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    add(button);
    add(startText);
    return super.onLoad();
  }
}
