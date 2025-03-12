import 'dart:convert';

import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergame/map.dart';
import 'package:fluttergame/serverconnection.dart';

class ShooterGame extends FlameGame {
  late List<List<int>> tileMap;
  late GameMap gameMap;

  @override
  Future<void> onLoad() async {
    print("[ShooterGame] onLoad() called");

    gameMap = GameMap();
    await add(gameMap); // Ensure map is added

    camera.moveTo(Vector2(200, 200)); // Move the camera to center
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(800, 600),
    ); // Set viewport

    print("[ShooterGame] GameMap added.");
  }

  @override
  void update(double dt) {
    // Game logic (handled on server in multiplayer mode)
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    loadMap();
    // Draw map, player, enemies, and bullets
  }

  Future<void> loadMap() async {
    final String jsonString = await rootBundle.loadString(
      'assets/game_data.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    tileMap = List<List<int>>.from(
      jsonData["levels"][0]["layers"][0]["tileMap"].map(
        (row) => List<int>.from(row),
      ),
    );
  }

  void setupWebSocket() {
    final webSocket = GameWebSocket();
    webSocket.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['type'] == 'update') {
        print('Player ${data['player']} moved to ${data['x']}, ${data['y']}');
      }
    });
  }
}

extension on CameraComponent {
  void followComponent(GameMap gameMap) {}
}
