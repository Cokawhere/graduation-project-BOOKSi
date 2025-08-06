class BookDetailsModel {
  final String id;
  final String coverImage;
  final List<String> images;
  final String title;
  final String author;
  final String genre;
  final double price;
  final String description;
  final double averageRating;
  final int totalRatings;
  final String condition;
  final List<String> availableFor;
  final String location;
  final String ownerRole;
  final String ownerId;

  BookDetailsModel({
    required this.id,
    required this.ownerId,
    required this.coverImage,
    required this.images,
    required this.title,
    required this.author,
    required this.genre,
    required this.price,
    required this.description,
    required this.averageRating,
    required this.totalRatings,
    required this.condition,
    required this.availableFor,
    required this.location,
    required this.ownerRole,
  });

  factory BookDetailsModel.fromMap(Map<String, dynamic> map, String role) {
    return BookDetailsModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      coverImage: map['coverImage'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      genre: map['genre'] ?? '',
      price: map['price'].toDouble(),
      description: map['description'] ?? '',
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      totalRatings: map['totalRatings'] ?? 0,
      condition: map['condition'] ?? '',
      availableFor: List<String>.from(map['availableFor'] ?? []),
      location: map['location'] ?? '',
      ownerRole: role,
    );
  }
}
