import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String bookId;
  final List<String> participants;
  final List<Message> messages;
  final String lastMessage;
  final String lastSenderId;
  final DateTime createdAt;
  final DateTime lastTimestamp;

  Chat({
    required this.bookId,
    required this.participants,
    required this.messages,
    required this.lastMessage,
    required this.lastSenderId,
    required this.createdAt,
    required this.lastTimestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      bookId: json['bookId'],
      participants: List<String>.from(json['participants'] ?? []),
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      lastMessage: json['lastMessage'],
      lastSenderId: json['lastSenderId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastTimestamp: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'participants': participants,
      'messages': messages.map((message) => message.toJson()).toList(),
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastTimestamp': Timestamp.fromDate(lastTimestamp),
    };
  }

  Chat copyWith({
    String? bookId,
    List<String>? participants,
    List<Message>? messages,
    String? lastMessage,
    String? lastSenderId,
    DateTime? createdAt,
    DateTime? lastTimestamp,
  }) {
    return Chat(
      bookId: bookId ?? this.bookId,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      createdAt: createdAt ?? this.createdAt,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
    );
  }
}

class Message {
  final String senderId;
  final String content;
  final bool read;
  final DateTime timestamp;
  final String? type; // "text" | "offer" | "system"

  Message({
    required this.senderId,
    required this.content,
    required this.read,
    required this.timestamp,
    this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      content: json['content'],
      read: json['read'] ?? false,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'read': read,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type,
    };
  }

  Message copyWith({
    String? senderId,
    String? content,
    bool? read,
    DateTime? timestamp,
    String? type,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      read: read ?? this.read,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }
}

class ChatPreview {
  final String chatId;
  final String bookId;
  final List<String> participants;
  final Message? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String bookTitle;
  final String bookAuthor;
  final String otherParticipantName;
  final String otherParticipantPhotoUrl;

  ChatPreview({
    required this.chatId,
    required this.bookId,
    required this.participants,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.bookTitle,
    required this.bookAuthor,
    required this.otherParticipantName,
    required this.otherParticipantPhotoUrl,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      chatId: json['chatId'],
      bookId: json['bookId'],
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      bookTitle: json['bookTitle'] ?? '',
      bookAuthor: json['bookAuthor'] ?? '',
      otherParticipantName: json['otherParticipantName'] ?? '',
      otherParticipantPhotoUrl: json['otherParticipantPhotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'bookId': bookId,
      'participants': participants,
      'lastMessage': lastMessage?.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'otherParticipantName': otherParticipantName,
      'otherParticipantPhotoUrl': otherParticipantPhotoUrl,
    };
  }
}
