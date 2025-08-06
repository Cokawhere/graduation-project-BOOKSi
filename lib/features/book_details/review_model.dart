import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String comment;
  final Timestamp createdAt;
  final int rating;
  final String reviewId;
  final String reviewerId;
  final String targetId;

  Review({
    required this.comment,
    required this.createdAt,
    required this.rating,
    required this.reviewId,
    required this.reviewerId,
    required this.targetId,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      rating: (map['rating'] ?? 0).toInt(),
      reviewId: map['reviewId'] ?? '',
      reviewerId: map['reviewerId'] ?? '',
      targetId: map['targetId'] ?? '',
    );
  }
}