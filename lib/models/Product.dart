class Product {
  final int productId;
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String productimg;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.productimg,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productID'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      price:
          json['price'] != null
              ? (json['price'] is int
                  ? (json['price'] as int).toDouble()
                  : json['price'])
              : 0.0,
      productimg: json['productimg'] ?? '',
    );
  }
}
