// import 'package:poker_flutter_game/table/cards/card.dart';

class Player {
  late String name;
  late String roomId;
  late int? playerType;
  late bool isPlayersTurn = false;
  late String playerNameTurn = "";
  late List swappedUsersList = [];
  late List playerCardsDisplay = [];
  late bool hasStartedGame = false;
  late int turn = 0;
  late int turnCount = 0;
  late double cash = 0.0;
  late double roomBet = 0.0;
  late double lastBet = 0.0;
  late double bet = 0.0;
  late List winners = [];
  late int flipUpIndex = 0;

  // late int current_turn = 0;
  // ignore: non_constant_identifier_names
  late String playerId;

  Player(this.name, this.roomId, this.playerType, this.playerId);

  Player.justID(this.playerId);

  set setPlayerType(int setPlayerType) {}

  set type(int type) {
    playerType = type;
  }
}
