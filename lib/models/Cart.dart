class Cart {
  final int productID;
  final String name;
  final double price;
  final String description;
  final String productimg;
  final int quantity;

  Cart({
    required this.productID,
    required this.name,
    required this.price,
    required this.description,
    required this.productimg,
    required this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productID: json['productID'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      productimg: json['productimg'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'name': name,
      'price': price,
      'description': description,
      'productimg': productimg,
      'quantity': quantity,
    };
  }
}
