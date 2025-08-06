import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final String bookId;
  final String? transactionId;
  final List<String> participants;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.chatId,
    required this.bookId,
    this.transactionId,
    required this.participants,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      bookId: json['bookId'],
      transactionId: json['transactionId'],
      participants: List<String>.from(json['participants'] ?? []),
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'bookId': bookId,
      'transactionId': transactionId,
      'participants': participants,
      'messages': messages.map((message) => message.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Chat copyWith({
    String? chatId,
    String? bookId,
    String? transactionId,
    List<String>? participants,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      bookId: bookId ?? this.bookId,
      transactionId: transactionId ?? this.transactionId,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Message {
  final String messageId;
  final String senderId;
  final String content;
  final bool read;
  final DateTime timestamp;
  final String? type; // "text" | "offer" | "system"

  Message({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.read,
    required this.timestamp,
    this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      senderId: json['senderId'],
      content: json['content'],
      read: json['read'] ?? false,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'content': content,
      'read': read,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type,
    };
  }

  Message copyWith({
    String? messageId,
    String? senderId,
    String? content,
    bool? read,
    DateTime? timestamp,
    String? type,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
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
  final String? transactionId;
  final List<String> participants;
  final Message? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String bookTitle;
  final String bookAuthor;
  final String bookCoverImage;
  final String otherParticipantName;
  final String otherParticipantPhotoUrl;

  ChatPreview({
    required this.chatId,
    required this.bookId,
    this.transactionId,
    required this.participants,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverImage,
    required this.otherParticipantName,
    required this.otherParticipantPhotoUrl,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      chatId: json['chatId'],
      bookId: json['bookId'],
      transactionId: json['transactionId'],
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      bookTitle: json['bookTitle'] ?? '',
      bookAuthor: json['bookAuthor'] ?? '',
      bookCoverImage: json['bookCoverImage'] ?? '',
      otherParticipantName: json['otherParticipantName'] ?? '',
      otherParticipantPhotoUrl: json['otherParticipantPhotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'bookId': bookId,
      'transactionId': transactionId,
      'participants': participants,
      'lastMessage': lastMessage?.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'bookCoverImage': bookCoverImage,
      'otherParticipantName': otherParticipantName,
      'otherParticipantPhotoUrl': otherParticipantPhotoUrl,
    };
  }
}
