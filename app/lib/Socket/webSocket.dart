import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:nextgen_software/scopedModel/app_model.dart';

class WebSocketService {
  final String url = 'wss://5a22-2-51-16-105.ngrok-free.app/ws';
  late WebSocketChannel channel;
  final AppModel model;  // Add AppModel reference

  WebSocketService(this.model);  // Pass AppModel instance when initializing

  // Connect to WebSocket server
  void connectToWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse(url));
    print('Connected to WebSocket');

    // Listen for messages from WebSocket server
    channel.stream.listen(
          (message) {
        _onMessageReceived(message);
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      onError: (error) {
        print('Error occurred: $error');
      },
    );
  }

  // Handle incoming messages from WebSocket
  void _onMessageReceived(dynamic message) {
    final data = json.decode(message);
    String deviceId = data['device_id'];
    String newState = data['state'];

    // Log update
    print('Device $deviceId updated to state: $newState');

    // Fetch updated device state from backend using AppModel
    model.getDevices();
  }

  // Send a message to the WebSocket server
  void sendMessage(String message) {
    channel.sink.add(message);
  }

  // Close the WebSocket connection
  void closeConnection() {
    channel.sink.close(status.goingAway);
  }
}
