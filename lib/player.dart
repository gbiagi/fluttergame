import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fluttergame/game.dart';
import 'package:fluttergame/serverconnection.dart';

class Player extends SpriteComponent with HasGameRef<ShooterGame> {
  final GameWebSocket webSocket;
  JoystickComponent joystick = JoystickComponent(
    knob: CircleComponent(radius: 15, paint: Paint()..color = Colors.white),
    background: CircleComponent(
      radius: 30,
      paint: Paint()..color = Colors.grey,
    ),
    margin: EdgeInsets.only(left: 50, bottom: 50),
  );

  Player(this.joystick, this.webSocket);

  @override
  void update(double dt) {
    position.add(joystick.relativeDelta * 100 * dt);
    webSocket.sendMove(position.x, position.y);
  }
}
