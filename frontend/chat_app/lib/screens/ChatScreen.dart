import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String senderName;
  final String userId;
  final WebSocketChannel channel;

  const ChatScreen({
    Key? key,
    required this.senderId,
    required this.senderName,
    required this.userId,
    required this.channel,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  late Stream<dynamic> _broadcastStream; // Store the broadcast stream

  @override
  void initState() {
    super.initState();

    // Convert WebSocket stream to a broadcast stream to allow multiple listeners
    _broadcastStream = widget.channel.stream.asBroadcastStream();

    _broadcastStream.listen(
      (message) {
        print("📩 WebSocket received: $message");
        final data = json.decode(message);

        if (data['type'] == 'chat_message' &&
            (data['sender_id'] == widget.senderId || data['receiver_id'] == widget.senderId)) {
          setState(() {
            messages.add({
              'sender_id': data['sender_id'],
              'message': data['message'],
              'timestamp': data['timestamp'],
            });
          });
        }
      },
      onDone: () => print("✅ WebSocket closed"),
      onError: (error) => print("⚠️ WebSocket error: $error"),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageData = {
        'type': 'chat_message',
        'sender_id': widget.userId,
        'receiver_id': widget.senderId,
        'message': _messageController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      widget.channel.sink.add(json.encode(messageData));

      setState(() {
        messages.add(messageData);
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    widget.channel.sink.close(); // Close WebSocket connection
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.senderName),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isMine = message['sender_id'] == widget.userId;

                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMine ? Colors.blue : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
