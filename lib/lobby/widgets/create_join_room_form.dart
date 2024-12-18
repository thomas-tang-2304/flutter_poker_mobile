// import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:poker_flutter_game/table/index.dart';

// ignore: must_be_immutable
class CreateJoinRoomForm extends StatefulWidget {
  var game;
  CreateJoinRoomForm(this.game, {super.key});

  @override
  CreateJoinRoomFormState createState() {
    // ignore: no_logic_in_create_state
    return CreateJoinRoomFormState(game);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateJoinRoomFormState extends State<CreateJoinRoomForm> {
  // ignore: prefer_typing_uninitialized_variables
  var game;
  CreateJoinRoomFormState(this.game);
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        backgroundColor: const Color.fromARGB(106, 0, 0, 0),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(100),
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hoverColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            )),
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                        onPressed: () async {
                          print(_controller.text);

                          await game.socket.emit('create-rooms', {
                            "limit": 1000000,
                            "roomCode": _controller.text,
                            "firstBet": 100
                          });
                          await game.socket.emit('join', {
                            "username": game.player.name,
                            "roomCode": _controller.text,
                            "gameBalance": 100000
                          });
                          game.player.roomId = _controller.text;
                          game.player.cash = 100000.0;
                          await game.router.pop();
                          await game.router.pushRoute(Route(Poker.new));
                          await game.overlays.remove("roomCodePopup");
                        },
                        child: Text("Create"))))
          ],
        ));
  }
}
