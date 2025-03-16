import 'dart:convert';
import 'dart:async';
import 'package:chat_app/components/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageService {
  late WebSocketChannel channel;
  late Box<Message> messageBox;
  final String userId;
  bool isConnected = false;
  Timer? reconnectTimer;

  MessageService({required this.userId}) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _initHive();  // Ensure Hive is ready
    _connectWebSocket();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('messages')) {
      messageBox = await Hive.openBox<Message>('messages');
    } else {
      messageBox = Hive.box<Message>('messages');
    }
  }


  void _connectWebSocket() {
    if (isConnected) return; // Prevent multiple connections

    try {
      print("🔌 Connecting to WebSocket...");
      channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.1.37:8000/ws/chat/$userId/'),
      );

      channel.stream.listen(
        (message) {
          print("📩 WebSocket received: $message");
          final data = json.decode(message);
          if (data['type'] == 'chat_message') {
            _storeMessage(data);
          }
        },
        onDone: () {
          print("⚠️ WebSocket connection closed.");
          _handleDisconnection();
        },
        onError: (error) {
          print("❌ WebSocket error: $error");
          _handleDisconnection();
        },
      );

      isConnected = true;
      print("✅ WebSocket connected!");
    } catch (e) {
      print("⚠️ WebSocket connection failed: $e");
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    isConnected = false;
    reconnectTimer?.cancel();
    reconnectTimer = Timer(const Duration(seconds: 5), _connectWebSocket);
  }

  void _storeMessage(Map<String, dynamic> data) {
    if (!data.containsKey('message')) return;

    final message = Message(
      sender: data['sender']?.toString() ?? 'unknown',
      senderName: data['senderName'] ?? 'Unknown',
      message: data['message'] ?? '',
      timestamp: (data['timestamp']?.toString()) ?? DateTime.now().toIso8601String(), // ✅ Convert to String
      recipient: data['recipient']?.toString() ?? '',
    );
  print("📤 Received message: $message");
    if (message.recipient == userId || message.sender == userId) {
      messageBox.add(message);
      print("✅ Stored message in Hive");
    }
  }


  void sendMessage(String recipientId, String senderName, String text) {
    if (!isConnected) {
      print("❌ WebSocket not connected. Cannot send message.");
      return;
    }

    final messageData = {
      "type": "chat_message",
      "sender": userId,
      "senderName": senderName,
      "recipient": recipientId,
      "message": text,
      "timestamp": DateTime.now().toIso8601String(),
    };

    print("📤 Sending message: $messageData");
    channel.sink.add(jsonEncode(messageData));

    // ✅ Store sent messages in Hive
    final message = Message(
      sender: userId,
      senderName: senderName,
      message: text,
      timestamp: DateTime.now().toIso8601String(),
      recipient: recipientId,
    );

    messageBox.add(message);
  }

  List<Message> getLatestMessages() {
    return messageBox.values
        .where((msg) => msg.sender == userId || msg.recipient == userId)
        .toList();
  }

  void dispose() {
    channel.sink.close();
    reconnectTimer?.cancel();
  }
}
