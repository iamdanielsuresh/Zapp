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
  late MessageService messageService;

  @override
  void initState() {
    super.initState();
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
        valueListenable: Hive.box<Message>('messages').listenable(),
        builder: (context, Box<Message> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No messages"));
          }

          // Keep only the latest message per conversation
          Map<String, Message> latestMessages = {};
          
          for (var msg in box.values) {
            // Get the other user's ID (either sender or recipient)
            String otherId = msg.sender == widget.userId ? msg.recipient : msg.sender;
            
            // Only update if this is a more recent message
            if (!latestMessages.containsKey(otherId) ||
                DateTime.parse(msg.timestamp).isAfter(
                  DateTime.parse(latestMessages[otherId]!.timestamp))) {
              latestMessages[otherId] = msg;
            }
          }

          // Convert to list and sort by timestamp
          List<Message> uniqueMessages = latestMessages.values.toList()
            ..sort((a, b) => DateTime.parse(b.timestamp).compareTo(
                  DateTime.parse(a.timestamp)));

          return ListView.builder(
            itemCount: uniqueMessages.length,
            itemBuilder: (context, index) {
              var message = uniqueMessages[index];
              String displayName = message.sender == widget.userId 
                  ? message.recipient 
                  : message.senderName;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(displayName[0].toUpperCase()),
                ),
                title: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  DateTime.parse(message.timestamp)
                      .toLocal()
                      .toString()
                      .substring(11, 16),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  String chatUserId = message.sender == widget.userId 
                      ? message.recipient 
                      : message.sender;
                      
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        senderName: displayName,
                        userId: widget.userId,
                        senderId: chatUserId,
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
}
