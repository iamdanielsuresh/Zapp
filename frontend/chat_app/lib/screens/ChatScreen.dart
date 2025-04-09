import 'package:chat_app/components/message_model.dart';
import 'package:flutter/material.dart';
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
  late MessageService messageService;

  @override
  void initState() {
    super.initState();
    messageService = MessageService(userId: widget.userId);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    messageService.sendMessage(
      widget.senderId,
      widget.senderName,
      _messageController.text.trim(),
    );

    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    messageService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.senderName),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: messageService.getConversationMessages(widget.senderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.sender == widget.userId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              DateTime.parse(message.timestamp)
                                  .toLocal()
                                  .toString()
                                  .substring(11, 16),
                              style: TextStyle(
                                fontSize: 12,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
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
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
