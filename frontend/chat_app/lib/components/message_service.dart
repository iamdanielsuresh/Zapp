import 'dart:convert';
import 'dart:async';
import 'package:chat_app/components/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageService {
  late WebSocketChannel channel;
  Map<String, Box<Message>> _messageBoxes = {};
  final String userId;
  bool isConnected = false;
  Timer? reconnectTimer;

  MessageService({required this.userId}) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _initHive();
    _connectWebSocket();
  }

  Future<void> _initHive() async {
    // Open or get the main messages box
    if (!Hive.isBoxOpen('messages')) {
      await Hive.openBox<Message>('messages');
    }
    
    // Open or get user-specific conversation boxes
    if (!Hive.isBoxOpen('conversations_$userId')) {
      await Hive.openBox<Message>('conversations_$userId');
    }
  }

  Box<Message> _getOrCreateConversationBox(String otherUserId) {
    // Create a consistent box name regardless of who initiated the conversation
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String boxName = 'conversation_${ids.join('_')}';
    
    if (!_messageBoxes.containsKey(boxName)) {
      if (!Hive.isBoxOpen(boxName)) {
        _messageBoxes[boxName] = Hive.openBox<Message>(boxName) as Box<Message>;
      } else {
        _messageBoxes[boxName] = Hive.box<Message>(boxName);
      }
    }
    return _messageBoxes[boxName]!;
  }

  void _connectWebSocket() {
    if (isConnected) return; // Prevent multiple connections

    try {
      print("🔌 Connecting to WebSocket...");
      channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.1.34:8000/ws/chat/$userId/'),
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
    final message = Message.fromJson(data);
    final otherUserId = message.sender == userId ? message.recipient : message.sender;
    
    // Store in conversation-specific box
    final conversationBox = _getOrCreateConversationBox(otherUserId);
    conversationBox.add(message);

    // Also store in the main messages box for the messages list
    final mainBox = Hive.box<Message>('messages');
    mainBox.add(message);
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

    final conversationBox = _getOrCreateConversationBox(recipientId);
    conversationBox.add(message);

    final mainBox = Hive.box<Message>('messages');
    mainBox.add(message);
  }

  Future<List<Message>> getConversationMessages(String otherUserId) async {
    final box = _getOrCreateConversationBox(otherUserId);
    return box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<Message> getLatestMessages() {
    return Hive.box<Message>('messages').values
        .where((msg) => msg.sender == userId || msg.recipient == userId)
        .toList();
  }

  void dispose() {
    channel.sink.close();
    reconnectTimer?.cancel();
    // Close all opened boxes
    _messageBoxes.values.forEach((box) {
      if (box.isOpen) {
        box.close();
      }
    });
  }
}
