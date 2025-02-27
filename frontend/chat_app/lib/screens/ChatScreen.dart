import 'package:chat_app/components/ChatBubble.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final int userId;

  ChatScreen({required this.userId}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cameron")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ChatBubble(text: "What do you mean?", isSent: false),
                ChatBubble(text: "I think the idea that things are changing isn't good", isSent: true),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
