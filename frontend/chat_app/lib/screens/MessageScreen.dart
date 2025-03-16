import 'package:chat_app/components/message_service.dart';
import 'package:chat_app/screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app/components/message_model.dart';

class MessagesScreen extends StatefulWidget {
  final String userId;

  const MessagesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late Box<Message> messagesBox;
  late MessageService messageService;

  @override
  void initState() {
    super.initState();
    messagesBox = Hive.box<Message>('messages');
    messageService = MessageService(userId: widget.userId);
  }

  @override
  void dispose() {
    messageService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: ValueListenableBuilder(
        valueListenable: messagesBox.listenable(),
        builder: (context, Box<Message> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No messages"));
          }

          // Keep only the latest message per sender
          Map<String, Message> latestMessages = {};

          for (var msg in box.values) {
            if (msg.sender.isNotEmpty || msg.sender != widget.userId) {
              latestMessages[msg.sender] = msg;
            }
          }

          // Convert to list and sort by timestamp (latest first)
          List<Message> uniqueMessages = latestMessages.values.toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return ListView.builder(
            itemCount: uniqueMessages.length,
            itemBuilder: (context, index) {
              var message = uniqueMessages[index];

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  message.sender,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _formatTimestamp(message.timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        senderName: message.sender,
                        userId: widget.userId,
                        senderId: message.sender,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    int parsedTimestamp;

    if (timestamp is int) {
      parsedTimestamp = timestamp;
    } else if (timestamp is String) {
      parsedTimestamp = int.tryParse(timestamp) ?? 0; // Safely convert
    } else {
      return "Invalid Time"; // Handle unexpected values
    }

    DateTime date = DateTime.fromMillisecondsSinceEpoch(parsedTimestamp);
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}"; // HH:MM format
  }
}
