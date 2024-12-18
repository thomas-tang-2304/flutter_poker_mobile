// import 'dart:convert';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:poker_flutter_game/components/bar_navigation.dart';
import 'package:poker_flutter_game/home/index.dart';
import 'package:poker_flutter_game/lobby/index.dart';
import 'package:poker_flutter_game/player/player.dart';
import 'package:poker_flutter_game/table/index.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';

class RouterGame extends FlameGame with TapCallbacks {
  late Player player = Player.justID(const Uuid().v1());

  late bool menuPopupToggle = false;
  late NavBar navBar = NavBar();
  late Socket socket;
  @override
  // Color backgroundColor() => Color.fromARGB(255, 230, 92, 58);
  Color backgroundColor() => Color.fromARGB(255, 143, 90, 6);
  late final RouterComponent router = RouterComponent(
    routes: {
      'home': Route(HomePage.new),
      'gameplay': Route(Poker.new),
      "lobby": Route(LobbyPage.new)
    },
    initialRoute: 'home',
  );

  @override
  void onLoad() async {
    dynamic detailBet = {};
    try {
      socket = io("https://poker-be-03kn.onrender.com", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        // 'query': {'token': 'THIS IS MY TOKEN FOR AUTHENTICATION'}
      });

      socket.onConnect((_socket) {
        player.roomBet = 0.0;
        player.swappedUsersList = [];
        print('connect');
        print(_socket);
      });

      socket.on("got-turn", (turn) async {
        if (player.lastBet < await turn["data"]["lastBet"].toDouble()) {
          player.turnCount = 1;
          player.turn = 1;
        } else {
          player.turnCount++;
          player.turn =
              (player.turn + 1) % turn["data"]["usersTurn"].length as int;
        }
        while (await turn["data"]["usersTurn"][player.turn]["fold"] == true) {
          player.turn =
              (player.turn + 1) % turn["data"]["usersTurn"].length as int;
        }
        player.roomBet += player.bet;
        player.lastBet = await turn["data"]["lastBet"].toDouble();

        if (player.name ==
            await turn["data"]["usersTurn"][player.turn]["username"]) {
          player.isPlayersTurn = true;
        } else {
          player.isPlayersTurn = false;
        }
        player.playerNameTurn =
            await turn["data"]["usersTurn"][player.turn]["username"];

        detailBet[player.name] = {"bet": player.lastBet, "allIn": false};

        if (player.turnCount ==
                await turn["data"]["usersTurn"]
                    .where((res) => res["fold"] == false)
                    .toList()
                    .length &&
            player.name == await turn["data"]["usersTurn"][0]["username"]) {
          socket.emit("bet", {
            "roomCode": player.roomId,
            "detailBet": detailBet,
            "totalBet": player.roomBet
          });
        }
      });

      socket.on("folded", (foldResult) async {
        if (foldResult["data"]["usersTurn"]
                .where((res) => res["fold"] == false)
                .toList()
                .length ==
            1) {
          player.hasStartedGame = false;
          player.isPlayersTurn = false;
          player.winners = foldResult["data"]["usersTurn"]
              .where((res) => res["fold"] == false)
              .toList();
        } else {
          if (player.turn >= foldResult["data"]["usersTurn"].length - 1) {
            player.turn = 0;
          } else {
            while (
                foldResult["data"]["usersTurn"][player.turn]["fold"] == true) {
              player.turn = (player.turn + 1) %
                  foldResult["data"]["usersTurn"].length as int;
            }
          }

          
          player.playerNameTurn =
              await foldResult["data"]["usersTurn"][player.turn]["username"];

          if (player.name == player.playerNameTurn) {
            player.isPlayersTurn = true;
          } else {
            player.isPlayersTurn = false;
          }

          detailBet[player.name] = {"bet": player.lastBet, "allIn": false};

          if (player.turnCount ==
                  await foldResult["data"]["usersTurn"]
                      .where((res) => res["fold"] == false)
                      .toList()
                      .length &&
              player.name ==
                  await foldResult["data"]["usersTurn"][0]["username"]) {
            socket.emit("bet", {
              "roomCode": player.roomId,
              "detailBet": detailBet,
              "totalBet": player.roomBet
            });
          }
        }
        // player.turn = await turn["data"]["turn"];
      });
    } catch (err) {
      print('ConnectionScreen -> initState -> err ->');
      print(err);
    }
    add(navBar);
    // add(camera);
    add(router);
  }

  @override
  void update(double dt) {
    if (menuPopupToggle) {
      super.add(navBar.menuPopup);
    } else {
      if (navBar.menuPopup.isMounted) {
        super.remove(navBar.menuPopup);
      }
    }
    // print(children.length);
    super.update(dt);
  }
}
