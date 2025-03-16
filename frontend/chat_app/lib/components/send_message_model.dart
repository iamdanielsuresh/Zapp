class SendMessage {
  final String sender;
  final String recipient; // Specify who receives the message
  final String message;
  final String timestamp;

  SendMessage({
    required this.sender,
    required this.recipient,
    required this.message,
    required this.timestamp,
  });

  // Convert to Hive-storable Message model
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'recipient': recipient,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
