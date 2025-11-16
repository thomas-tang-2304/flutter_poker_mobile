// import 'dart:convert';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:poker_flutter_game/components/bar_navigation.dart';
import 'package:poker_flutter_game/home/index.dart';
import 'package:poker_flutter_game/lobby/index.dart';
import 'package:poker_flutter_game/player/player.dart';
import 'package:poker_flutter_game/table/index.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';
import 'package:flame_audio/flame_audio.dart';

class RouterGame extends FlameGame with TapCallbacks {
  late Player player = Player.justID(const Uuid().v1());

  late bool menuPopupToggle = false;
  late NavBar navBar = NavBar();
  late Socket socket;
  @override
  // Color backgroundColor() => Color.fromARGB(255, 230, 92, 58);
  Color backgroundColor() => const Color.fromARGB(255, 143, 90, 6);
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

    Map<String, Map<String, dynamic>> detailBet = {};
    try {
      const audioPath = 'melody-ambient-handpan-lofi-loop-dmin-120bpm-227398.mp3';
      // FlameAudio.audioCache.load(audioPath);

      // 2. Start background music (looping)
      // FlameAudio.loop(audioPath, volume: 0.5); 
      
      // Use FlameAudio.bgm.play('bg_music.mp3'); for more advanced BGM controls
      // socket = io("https://poker-be-03kn.onrender.com", <String, dynamic>{
      //   'transports': ['websocket'],
      //   'autoConnect': true,
      //   // 'query': {'token': 'THIS IS MY TOKEN FOR AUTHENTICATION'}
      // });
      socket = io("http://localhost:3001", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        // 'query': {'token': 'THIS IS MY TOKEN FOR AUTHENTICATION'}
      });

      socket.onConnect((socketConnector) {
        player.roomBet = 0.0;
        player.swappedUsersList = [];
         if (kDebugMode) {
          print('connect');
        }
        // print(_socket);
      });

      socket.on("got-turn", (turn) async {
        print(turn);
        var turnData = turn["data"];
        var usersTurn = turnData["usersTurn"];
        if (player.lastBet < turnData["lastBet"].toDouble()) {
          player.turnCount = 1;
          player.turn = 1;
        } else {
          player.turnCount++;
          player.turn =
              (player.turn + 1) % usersTurn.length as int;
        }
        while (usersTurn[player.turn]["fold"] == true) {
          player.turn =
              (player.turn + 1) % usersTurn.length as int;
        }
        player.roomBet += player.bet;
        player.lastBet = turnData["lastBet"].toDouble();

        if (player.name == usersTurn[player.turn]["username"]) {
          player.isPlayersTurn = true;
        } else {
          player.isPlayersTurn = false;
        }

        player.playerNameTurn = usersTurn[player.turn]["username"];

        detailBet[player.playerNameTurn] = {"bet": player.lastBet, "allIn": false};
        print(detailBet);
        var activePlayers = usersTurn
                    .where((res) => res["fold"] == false)
                    .toList();
     
        if (player.turnCount == activePlayers.length && player.name == usersTurn[0]["username"]) {
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

          detailBet[player.playerNameTurn] = {"bet": player.lastBet, "allIn": false};

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
       
      });
    } catch (err) {
      if (kDebugMode) {
        print('ConnectionScreen -> initState -> err ->');
        print(err);
      }
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
  @override
  void onRemove() {
    socket.emit('leave', {
      "roomCode": player.roomId,
      "username": player.name,
      "gameBalance": player.cash 
    });
    removeAll(children.where((child) => child.isMounted));
    Flame.images.clearCache();
    Flame.assets.clearCache();
    FlameAudio.bgm.stop(); // If you used FlameAudio.bgm.play
    super.onRemove();
  }
}
