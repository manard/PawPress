class Product {
  int productId;
  String productName;
  double price;
  String description;
  int quantity;
  String imagePath;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.description,
    required this.quantity,
    required this.imagePath,
  });

  

  // to add product
  static void addProduct(List<Product> products, Product newProduct) {
    products.add(newProduct);
    print('Product added: ${newProduct.productName}');
  }

  // to remove product
  static void removeProduct(List<Product> products, int productId) {
    products.removeWhere((product) => product.productId == productId);
    print('Product with ID $productId removed');
  }

  // to update products
  static void updateProduct(
    List<Product> products,
    int productId, {
    String? productName,
    double? price,
    String? description,
    int? quantity,
  }) {
    for (var product in products) {
      if (product.productId == productId) {
        if (productName != null) product.productName = productName;
        if (price != null) product.price = price;
        if (description != null) product.description = description;
        if (quantity != null) product.quantity = quantity;
        print('Product with ID $productId updated');
        return;
      }
    }
    print('Product with ID $productId not found');
  }
}
