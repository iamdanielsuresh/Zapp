import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String sender;

  @HiveField(1)
  final String senderName;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final String timestamp;

  @HiveField(4)
  final String recipient;

  Message({
    required this.sender,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.recipient,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] ?? "",  // Prevent null values
      senderName: json['senderName'] ?? "Unknown",
      message: json['message'] ?? "",
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      recipient: json['recipient'] ?? "",
    );
  }
}
