import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthAPI {
  Future<Map<String, dynamic>> socialLogin(
      String username, String password, String email) async {
    var response;
    try {
      response = await http.post(
        Uri.parse('https://poker-be-03kn.onrender.com/social-login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "username": username,
          "password": password
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
      return {"message": 'Failed to login'};
    }

    
  }

  Future<Map<String, dynamic>> signUp(
      String username, String password, String email) async {
    var response;
    try {
      response = await http.post(
        Uri.parse('https://poker-be-03kn.onrender.com/signup/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "username": username,
          "password": password
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
      return {"message": 'Failed to signup'};
    }
  }
}
