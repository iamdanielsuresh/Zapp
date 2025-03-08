import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'ChatScreen.dart'; // Import the chat screen

class MessagesScreen extends StatefulWidget {
  final String userId;
  const MessagesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late WebSocketChannel channel;
  Map<String, Map<String, dynamic>> latestMessages = {}; // Stores only the latest message per sender
  bool isConnected = false;
  Timer? reconnectTimer;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    if (isConnected) return;

    try {
      channel = WebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8000/ws/chat/${widget.userId}/'),
      );

      channel!.stream.listen(
        (message) {
          print("📩 Received WebSocket message: $message");
          try {
            final data = json.decode(message);

            if (data['type'] == 'chat_message') {
              _updateLatestMessage(data);
            }
          } catch (e) {
            print("❌ Error parsing WebSocket message: $e");
          }
        },
        onDone: _handleDisconnection,
        onError: (error) {
          print("⚠️ WebSocket Error: $error");
          _handleDisconnection();
        },
      );

      setState(() => isConnected = true);
    } catch (e) {
      print("❌ WebSocket Connection Failed: $e");
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    setState(() => isConnected = false);
    reconnectTimer?.cancel();
    reconnectTimer = Timer(const Duration(seconds: 5), _connectWebSocket);
  }

  void _updateLatestMessage(Map<String, dynamic> data) {
    String senderId = data['sender_id']?.toString() ?? 'unknown';
    String senderName = data['sender'] ?? 'Unknown';
    String lastMessage = data['message'] ?? '';
    String timestamp = data['timestamp'] ?? DateTime.now().toIso8601String();
    bool online = data['online'] ?? false;

    if (lastMessage.isEmpty) return; // Ignore empty messages

    setState(() {
      latestMessages[senderId] = {
        'sender_name': senderName,
        'last_message': lastMessage,
        'timestamp': timestamp,
        'sender_id': senderId,
        'online': online,
      };
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    reconnectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> messagesList = latestMessages.values.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.black,
      ),
      body: messagesList.isEmpty
          ? const Center(
              child: Text(
                "No messages available",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: messagesList.length,
              itemBuilder: (context, index) {
                var message = messagesList[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      (message['sender_name'].isNotEmpty ? message['sender_name'][0] : '?').toUpperCase(),
                    ),
                  ),
                  title: Text(
                    message['sender_name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    message['last_message'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    _formatTimestamp(message['timestamp']),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          senderId: message['sender_id'],
                          senderName: message['sender_name'],
                          userId: widget.userId,
                          channel:channel,

                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime time = DateTime.parse(timestamp);
      return "${time.hour}:${time.minute}";
    } catch (e) {
      return "N/A";
    }
  }
}
