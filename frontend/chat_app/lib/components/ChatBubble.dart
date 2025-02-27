import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSent;

  ChatBubble({required this.text, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSent ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
