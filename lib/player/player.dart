
class Player {
  late String name;
  late int? playerType;
  // ignore: non_constant_identifier_names
  late String player_id;

  Player(this.name, this.playerType, this.player_id);

  Player.justID(this.player_id);

  set setPlayerType(int setPlayerType) {}

  set type(int type) {
    playerType = type;
  }
}
