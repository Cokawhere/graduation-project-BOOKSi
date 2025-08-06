class FilterModel {
  String? location;
  List<String> selectedGenres;
  double minPrice;
  double maxPrice;
  List<String> condition; 
  List<String> availableFor; 
  double? minRating;
  String? status;
  String? sortBy; 

  FilterModel({
    this.location,
    this.selectedGenres = const [],
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.condition = const [],
    this.availableFor = const [],
    this.minRating,
    this.status,
    this.sortBy,
  });

  Map<String, dynamic> toMap() => {
        'location': location,
        'selectedGenres': selectedGenres,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'condition': condition,
        'availableFor': availableFor,
        'minRating': minRating,
        'status': status,
        'sortBy': sortBy,
      };

  factory FilterModel.fromMap(Map<String, dynamic> map) => FilterModel(
        location: map['location'],
        selectedGenres: List<String>.from(map['selectedGenres'] ?? []),
        minPrice: (map['minPrice'] ?? 0).toDouble(),
        maxPrice: (map['maxPrice'] ?? 1000).toDouble(),
        condition: List<String>.from(map['condition'] ?? []),
        availableFor: List<String>.from(map['availableFor'] ?? []),
        minRating: map['minRating']?.toDouble(),
        status: map['status'],
        sortBy: map['sortBy'],
      );
}
