import 'package:poker_flutter_game/player/player.dart';

class Room {
  late List<Player> players;
  late String room_id;

  Room(this.players, this.room_id);

  Room.justID(this.room_id);
}
