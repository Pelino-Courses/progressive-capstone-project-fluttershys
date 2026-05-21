class Product {
  final String id;
  final String ownerId;
  final String ownerName;
  final String name;
  final String category;
  final double price;
  final String description;
  /// Asset path (`assets/...`) or absolute local file path from image picker.
  final String? imageUrl;
  final int stockQuantity;
  final bool isAvailable;
  final int popularity;
  final DateTime createdAt;
  final bool isApproved;

  const Product({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.name,
    required this.category,
    required this.price,
    this.description = '',
    this.imageUrl,
    this.stockQuantity = 0,
    required this.isAvailable,
    required this.popularity,
    required this.createdAt,
    this.isApproved = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'popularity': popularity,
      'createdAt': createdAt.toIso8601String(),
      'isApproved': isApproved,
    };
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: (map['id'] as String?) ?? '',
      ownerId: (map['ownerId'] as String?) ?? '',
      ownerName: (map['ownerName'] as String?) ?? 'Unknown',
      name: (map['name'] as String?) ?? 'Untitled Product',
      category: (map['category'] as String?) ?? 'General',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      description: (map['description'] as String?) ?? '',
      imageUrl: map['imageUrl'] as String?,
      stockQuantity: (map['stockQuantity'] as num?)?.toInt() ?? 0,
      isAvailable: (map['isAvailable'] as bool?) ?? true,
      popularity: (map['popularity'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isApproved: (map['isApproved'] as bool?) ?? true,
    );
  }

  Product copyWith({
    String? name,
    String? category,
    double? price,
    String? description,
    bool? isAvailable,
    String? imageUrl,
    int? stockQuantity,
    int? popularity,
    bool? isApproved,
  }) {
    return Product(
      id: id,
      ownerId: ownerId,
      ownerName: ownerName,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      popularity: popularity ?? this.popularity,
      createdAt: createdAt,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}
