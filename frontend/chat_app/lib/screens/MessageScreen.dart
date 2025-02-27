import 'dart:convert';
import 'package:chat_app/screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Stream<List<dynamic>> getMessagesStream() async* {
    while (true) {
      final response = await http.get(Uri.parse('https://mockapi.io/clone/67be34a0321b883e790f6717/messages'));
      if (response.statusCode == 200) {
        yield json.decode(response.body);
      } else {
        yield [];
      }
      await Future.delayed(Duration(seconds: 5)); // Fetch data every 5 seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: StreamBuilder<List<dynamic>>(
        stream: getMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No messages available"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var message = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey),
                title: Text(message['sender_name']),
                subtitle: Text(message['last_message']),
                trailing: Text(message['timestamp']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(userId: message['sender_id']),
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
