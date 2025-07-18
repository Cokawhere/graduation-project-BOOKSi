import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String ownerId;
  final String ownerType;
  final String title;
  final String author;
  final String isbn;
  final String genre;
  final double? averageRating;
  final int? totalRatings;
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
  final double? price;

  Book({
    required this.id,
    required this.ownerId,
    required this.ownerType,
    required this.title,
    required this.author,
    required this.isbn,
    required this.genre,
    this.averageRating,
    this.totalRatings,
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
    this.price,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      ownerId: map['ownerId'],
      ownerType: map['ownerType'],
      title: map['title'],
      author: map['author'],
      isbn: map['isbn'],
      genre: map['genre'],
      averageRating: map['averageRating']?.toDouble(),
      totalRatings: map['totalRatings'],
      description: map['description'],
      condition: map['condition'],
      availableFor: List<String>.from(map['availableFor']),
      approval: map['approval'],
      isDeleted: map['isDeleted'],
      status: map['status'],
      coverImage: map['coverImage'],
      images: List<String>.from(map['images']),
      location: map['location'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      price: map['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerType': ownerType,
      'title': title,
      'author': author,
      'isbn': isbn,
      'genre': genre,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'description': description,
      'condition': condition,
      'availableFor': availableFor,
      'approval': approval,
      'isDeleted': isDeleted,
      'status': status,
      'coverImage': coverImage,
      'images': images,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'price': price,

    };
  }
}
