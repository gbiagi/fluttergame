import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class GameMap extends Component {
  late List<List<int>> tileMap;
  late SpriteSheet spriteSheet;
  static const double tileSize = 32.0; // Adjust as needed

  GameMap();

  @override
  Future<void> onLoad() async {
    print("[GameMap] Loading map...");
    await loadMap();

    print("[GameMap] Loading sprite sheet...");
    await loadSpriteSheet();
  }

  Future<void> loadMap() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/game_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      tileMap = List<List<int>>.from(
        jsonData["levels"][0]["layers"][0]["tileMap"].map(
          (row) => List<int>.from(row),
        ),
      );

      print(
        "[GameMap] Parsed tilemap: ${tileMap.length} rows, ${tileMap[0].length} columns",
      );
    } catch (e) {
      print("[GameMap] Error loading map: $e");
    }
  }

  Future<void> loadSpriteSheet() async {
    try {
      final image = await Flame.images.load('tileset.png');
      spriteSheet = SpriteSheet(image: image, srcSize: Vector2(16, 16));

      print("[GameMap] Creating tile components...");
      // After loading, create tiles as children
      for (int y = 0; y < tileMap.length; y++) {
        for (int x = 0; x < tileMap[y].length; x++) {
          int tileIndex = tileMap[y][x];
          add(TileComponent(tileIndex, x, y, spriteSheet));
        }
      }
      print("[GameMap] Finished adding tile components.");
    } catch (e) {
      print("[GameMap] Error loading sprite sheet: $e");
    }
  }
}

class TileComponent extends SpriteComponent {
  TileComponent(int tileIndex, int x, int y, SpriteSheet spriteSheet)
    : super(
        sprite: spriteSheet.getSprite(
          tileIndex % spriteSheet.columns,
          tileIndex ~/ spriteSheet.columns,
        ),
        position: Vector2(x * 32.0, y * 32.0), // Adjust based on tile size
        size: Vector2(32.0, 32.0),
      );
}
