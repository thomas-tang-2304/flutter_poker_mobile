import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:poker_flutter_game/lobby/index.dart';
import 'package:poker_flutter_game/router.dart';
import 'package:poker_flutter_game/apis/auth.dart';
import 'package:poker_flutter_game/utils/text_render.dart';
import 'package:uuid/uuid.dart';

class HomeButton extends PositionComponent
    with TapCallbacks, HasGameReference<RouterGame> {
  late String buttonPath;
  late double x;
  late double y;
  late double w;
  late double h;
  late double _scale;

  var uuid = const Uuid();

  late var _rect;

  // Generative Constructor
  // ignore: non_constant_identifier_names
  HomeButton(String buttonPath, double x, double y, double w, double h,
      double _scale) {
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
    _rect = Rect.fromLTWH(
        x - w * _scale / 2, y - h * _scale / 2, w * _scale, h * _scale);
  }

  SpriteComponent button = SpriteComponent();

  void setUser(String name, int userType, String playerId) {
    game.player.type = userType;
    game.player.name = name;
    game.player.playerId = playerId;
  }

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());
  @override
  void onTapUp(TapUpEvent event) async {
    var uid = uuid.v1().toString();
    setUser("User$uid", 1, uid);
    game.router.pushRoute(Route(LobbyPage.new));
  }

  // @override
  // void onTapDown(TapDownEvent event) async {}

  @override
  FutureOr<void> onLoad() async {
    priority = 2;
    // ignore: unused_local_variable
    final game = findGame();
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

class FBLoginButton extends HomeButton {
  FBLoginButton(
      super.buttonPath, super.x, super.y, super.w, super.h, super.scale);

  late TextComponent<TextRenderer> renderText = TextComponent(
    scale: Vector2.all(4.0),
    text: "Đăng nhập thất bại",
    anchor: Anchor.center,
    position: Vector2(100 * 16, 53 * 16),
    textRenderer: regular,
  );
  @override
  void onTapUp(TapUpEvent event) async {
    button.y -= 2;
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
      ],
    );
    try {
      if (result.status == LoginStatus.success) {
        final Map<String, dynamic> userData = await FacebookAuth.i.getUserData(
          fields: "name,email,picture.width(200),birthday,friends,gender,link",
        );
        setUser(userData["name"], 2, uuid.v1());
        game.router.pushRoute(Route(LobbyPage.new));
      } else {
        add(renderText);
        print(result.status);
        print(result.message);
      }
    } catch (e) {
      add(renderText);
      print(e);
    }
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.y += 2;
  }
}

class GGLoginButton extends HomeButton {
  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  late TextComponent<TextRenderer> renderText = TextComponent(
    scale: Vector2.all(4.0),
    text: "Đăng nhập thất bại",
    anchor: Anchor.center,
    position: Vector2(100 * 16, 53 * 16),
    textRenderer: regular,
  );

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId:
        '572752990204-tj6v86bg9bp238ikoacs7vle0e19g1o0.apps.googleusercontent.com',
    scopes: scopes,
  );

  AuthAPI authAPI = AuthAPI();
  GGLoginButton(
      super.buttonPath, super.x, super.y, super.w, super.h, super.scale);
  @override
  void onTapUp(TapUpEvent event) async {
    button.y -= 2;
    try {
      await _googleSignIn.signIn().then((GoogleSignInAccount? value) {
        if (value?.displayName != null) {
          authAPI
              .signUp(value!.displayName!, "google", value.email)
              .then((value) {
            print(value);
          });

          setUser(value.displayName!, 3, uuid.v1());
          game.router.pushRoute(Route(LobbyPage.new));
        }
      });
    } catch (error) {
      add(renderText);
      print('signup failed');
      print(error);
    }
  }

  @override
  void onTapDown(TapDownEvent event) async {
    button.y += 2;
  }
}

class HomeButtonWithText extends HomeButton {
  late String popupText;

  HomeButtonWithText(this.popupText, super.buttonPath, super.x, super.y,
      super.w, super.h, super._scale,
      {required int priority});

  late TextComponent<TextRenderer> renderText = TextComponent(
      text: popupText,
      anchor: Anchor.center,
      position: Vector2(x, y),
      textRenderer: home_button_regular,
      priority: 5);

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    add(renderText);
    return super.onLoad();
  }
}
