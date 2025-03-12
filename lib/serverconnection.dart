import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class GameWebSocket {
  final _channel = IOWebSocketChannel.connect('ws://localhost:8080');

  void sendMove(double x, double y) {
    _channel.sink.add(
      jsonEncode({'type': 'move', 'player': '1', 'x': x, 'y': y}),
    );
  }

  Stream get stream => _channel.stream;
}
