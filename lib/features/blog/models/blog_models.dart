import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String userPhotoUrl;
  final String userName;
  final String content;
  final String? imageURL;
  final List<String>? likes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PostModel({
    required this.postId,
    required this.userId,
    required this.userPhotoUrl,
    required this.userName,
    required this.content,
    this.imageURL,
    this.likes,
    required this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      userPhotoUrl: json['userPhotoUrl'] ?? '',
      userName: json['userName'] ?? '',
      content: json['content'] ?? '',
      imageURL: json['imageURL'],
      likes: json['likes'] != null ? List<String>.from(json['likes']) : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userPhotoUrl': userPhotoUrl,
      'userName': userName,
      'content': content,
      'imageURL': imageURL,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  PostModel copyWith({
    String? postId,
    String? userId,
    String? userPhotoUrl,
    String? userName,
    String? content,
    String? imageURL,
    List<String>? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      imageURL: imageURL ?? this.imageURL,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CommentModel {
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String userName;
  final String userPhotoUrl;

  CommentModel({
    required this.userId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.userName,
    required this.userPhotoUrl,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['userId'],
      content: json['content'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      userName: json['userName'],
      userPhotoUrl: json['userPhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  CommentModel copyWith({
    String? userId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userName,
    String? userPhotoUrl,
  }) {
    return CommentModel(
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
    );
  }
}
