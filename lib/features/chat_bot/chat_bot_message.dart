import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBotMessage {
  final String? id;
  final String text;
  final String sender; // "user" | "bot"
  final DateTime? createdAt;

  ChatBotMessage({
    this.id,
    required this.text,
    required this.sender,
    this.createdAt,
  });

  factory ChatBotMessage.fromJson(Map<String, dynamic> json, {String? id}) {
    return ChatBotMessage(
      id: id,
      text: (json['text'] ?? '').toString(),
      sender: (json['sender'] ?? '').toString(),
      createdAt: (json['createdAt'] is Timestamp)
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': sender,
      // createdAt is intentionally omitted to allow serverTimestamp on writes
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }
}
