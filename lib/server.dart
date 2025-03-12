import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await HttpServer.bind('0.0.0.0', 8080);
  print('Server running on ws://localhost:8080');

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      handleConnection(socket);
    }
  }
}

final List<WebSocket> players = [];

void handleConnection(WebSocket socket) {
  players.add(socket);
  print('Player connected. Total players: ${players.length}');

  socket.listen(
    (message) {
      final data = jsonDecode(message);
      if (data['type'] == 'move') {
        broadcast(
          jsonEncode({
            'type': 'update',
            'player': data['player'],
            'x': data['x'],
            'y': data['y'],
          }),
        );
      }
    },
    onDone: () {
      players.remove(socket);
    },
  );
}

void broadcast(String message) {
  for (var player in players) {
    player.add(message);
  }
}
