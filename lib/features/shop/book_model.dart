import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String ownerId;
  final String ownerType;
  final String title;
  final String author;
  final String isbn;
  final String genre;
  final double averageRating;
  final int totalRatings;
  final String description;
  final String condition;
  final List<String> availableFor;
  final String approval;
  final bool isDeleted;
  final String status;
  final String coverImage;
  final List<String> images;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double price;
  final int quantity;  // New field added here

  Book({
    required this.id,
    required this.ownerId,
    required this.ownerType,
    required this.title,
    required this.author,
    required this.isbn,
    required this.genre,
    required this.averageRating,
    required this.totalRatings,
    required this.description,
    required this.condition,
    required this.availableFor,
    required this.approval,
    required this.isDeleted,
    required this.status,
    required this.coverImage,
    required this.images,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    required this.quantity,  // Added to constructor
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    try {
      return Book(
        id: map['id'] ?? '',
        ownerId: map['ownerId'] ?? '',
        ownerType: map['ownerType'] ?? '',
        title: map['title'] ?? '',
        author: map['author'] ?? '',
        isbn: map['isbn'] ?? '',
        genre: map['genre'] ?? '',
        averageRating: (map['averageRating'] ?? 0).toDouble(),
        totalRatings: map['totalRatings'] is int ? map['totalRatings'] : 0,
        description: map['description'] ?? '',
        condition: map['condition'] ?? '',
        availableFor: List<String>.from(map['availableFor'] ?? []),
        approval: map['approval'] ?? '',
        isDeleted: map['isDeleted'] ?? false,
        status: map['status'] ?? '',
        coverImage: map['coverImage'] ?? '',
        images: List<String>.from(map['images'] ?? []),
        location: map['location'],
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        price: (map['price'] ?? 0).toDouble(),
        quantity: map['quantity'] ?? 0,  // Parse new field, default to 0
      );
    } catch (e) {
      print(" Error parsing book: $e");
      print(" Data: $map");
      rethrow;
    }
  }
}