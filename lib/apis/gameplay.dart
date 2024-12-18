import 'dart:convert';
import 'package:http/http.dart' as http;

class GameplayAPI {
  Future<Map<String, dynamic>> fetchGamePlay(List<String> users) async {
    var response;
    try {
      response = await http.post(
        Uri.parse('https://poker-be-03kn.onrender.com/divide-cards/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"roomCode": "1234", "users": users}),
      );
    } catch (e) {
      print(e);
    }

    if (response?.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return {"message": 'Failed to load Gameplay'};
    }
  }

  Future<Map<String, dynamic>> checkHandRanking(String roomCode) async {
    var response;
    try {
      response = await http.post(
        Uri.parse('https://poker-be-03kn.onrender.com/hand-ranking/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "roomCode": roomCode,
        }),
      );
    } catch (e) {
      print(e);
    }

    if (response?.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return {"message": 'Failed to load Ranking'};
    }
  }
}
