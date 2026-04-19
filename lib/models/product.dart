mixin Discountable {
  double getDiscountedPrice(double price, double percent) => price * (1 - percent);
}

class Product with Discountable {
  final String id;
  final String name;
  final double price;
  final String? imageUrl; // Null safety: can be null if no image

  Product({
    required this.id, 
    required this.name, 
    required this.price, 
    this.imageUrl
  });
}
