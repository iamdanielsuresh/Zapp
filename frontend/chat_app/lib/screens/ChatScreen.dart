import 'package:chat_app/components/message_model.dart';
import 'package:chat_app/components/send_message_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app/components/message_service.dart';


class ChatScreen extends StatefulWidget {
  final String senderId; // The sender of messages
  final String senderName; // Name of the sender
  final String userId; // Current user (recipient)

  const ChatScreen({
    Key? key,
    required this.senderName,
    required this.userId, 
    required this.senderId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Box<Message> messagesBox;
  late MessageService messageService;

  @override
  void initState() {
    super.initState();
    messagesBox = Hive.box<Message>('messages');
    messageService = MessageService(userId: widget.userId);
  }

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    // New message instance (not stored in Hive)
    final sendMessage = SendMessage(
      sender: widget.userId,
      recipient: widget.senderId, // Recipient is the sender in this chat
      message: text,
      timestamp: DateTime.now().toIso8601String(),
    );

    // Convert `SendMessage` to `Message` before storing
    final newMessage = Message(
      sender: sendMessage.sender,
      senderName: widget.senderName,
      message: sendMessage.message,
      timestamp: sendMessage.timestamp,
      recipient: sendMessage.recipient,
    );

    messagesBox.add(newMessage); // Store in Hive
    messageService.sendMessage(widget.senderId, widget.senderName, text); // Send message to server
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
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
            child: ValueListenableBuilder(
              valueListenable: messagesBox.listenable(),
              builder: (context, Box<Message> box, _) {
                List<Message> messages = box.values
                  .where((msg) =>
                      (msg.sender == widget.userId && msg.recipient == widget.senderId) || // Sent messages
                      (msg.sender == widget.senderId && msg.recipient == widget.userId))   // Received messages
                  .toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMine = message.sender == widget.userId; // Correct sender check

                    return Align(
                      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMine ? Colors.blue : Colors.grey[800], // Different color for sender/receiver
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
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
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
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
