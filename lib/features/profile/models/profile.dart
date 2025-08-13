import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String role;
  final String photoUrl;
  final bool verified;
  final bool isBanned;
  final bool profileIncomplete;
  final List<String> genres;
  final List<String> bookIds;
  final List<String> transactionIds;
  final List<String> chatIds;
  final List<String> blogPostIds;
  final List<String> notificationIds;
  final double? averageRating;
  final int? totalRatings;
  final String? address;
  final String? website;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageFileId;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.role,
    required this.photoUrl,
    required this.verified,
    required this.isBanned,
    required this.profileIncomplete,
    required this.genres,
    required this.bookIds,
    required this.transactionIds,
    required this.chatIds,
    required this.blogPostIds,
    required this.notificationIds,
    this.averageRating,
    this.totalRatings,
    this.address,
    this.website,
    required this.createdAt,
    required this.updatedAt,
    this.imageFileId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      role: json['role'],
      photoUrl: json['photoUrl'],
      verified: json['verified'],
      isBanned: json['isBanned'],
      profileIncomplete: json['profileIncomplete'],
      genres: List<String>.from(json['genres'] ?? []),
      bookIds: List<String>.from(json['bookIds'] ?? []),
      transactionIds: List<String>.from(json['transactionIds'] ?? []),
      chatIds: List<String>.from(json['chatIds'] ?? []),
      blogPostIds: List<String>.from(json['blogPostIds'] ?? []),
      notificationIds: List<String>.from(json['notificationIds'] ?? []),
      averageRating: json['averageRating']?.toDouble(),
      totalRatings: json['totalRatings'],
      address: json['address'],
      website: json['website'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      imageFileId: json['imageFileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'role': role,
      'photoUrl': photoUrl,
      'verified': verified,
      'isBanned': isBanned,
      'profileIncomplete': profileIncomplete,
      'genres': genres,
      'bookIds': bookIds,
      'transactionIds': transactionIds,
      'chatIds': chatIds,
      'blogPostIds': blogPostIds,
      'notificationIds': notificationIds,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'address': address,
      'website': website,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'imageFileId': imageFileId,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? bio,
    String? role,
    String? photoUrl,
    bool? verified,
    bool? isBanned,
    bool? profileIncomplete,
    List<String>? genres,
    List<String>? bookIds,
    List<String>? transactionIds,
    List<String>? chatIds,
    List<String>? blogPostIds,
    List<String>? notificationIds,
    double? averageRating,
    int? totalRatings,
    String? address,
    String? website,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageFileId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      verified: verified ?? this.verified,
      isBanned: isBanned ?? this.isBanned,
      profileIncomplete: profileIncomplete ?? this.profileIncomplete,
      genres: genres ?? this.genres,
      bookIds: bookIds ?? this.bookIds,
      transactionIds: transactionIds ?? this.transactionIds,
      chatIds: chatIds ?? this.chatIds,
      blogPostIds: blogPostIds ?? this.blogPostIds,
      notificationIds: notificationIds ?? this.notificationIds,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      address: address ?? this.address,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageFileId: imageFileId ?? this.imageFileId,
    );
  }
}

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
  final String? imageFileId;

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
    this.imageFileId,
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
      imageFileId: map['imageFileId'],
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
      'imageFileId': imageFileId,
    };
  }

  Book copyWith({
    String? id,
    String? ownerId,
    String? ownerType,
    String? title,
    String? author,
    String? isbn,
    String? genre,
    double? averageRating,
    int? totalRatings,
    String? description,
    String? condition,
    List<String>? availableFor,
    String? approval,
    bool? isDeleted,
    String? status,
    String? coverImage,
    List<String>? images,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? price,
    String? imageFileId,
  }) {
    return Book(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerType: ownerType ?? this.ownerType,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      genre: genre ?? this.genre,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      availableFor: availableFor ?? this.availableFor,
      approval: approval ?? this.approval,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      coverImage: coverImage ?? this.coverImage,
      images: images ?? this.images,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      price: price ?? this.price,
      imageFileId: imageFileId ?? this.imageFileId,
    );
  }
}
