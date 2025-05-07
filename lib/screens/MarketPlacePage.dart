import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/models/product.dart';
import 'package:pawpress/screens/ProductDetailsPage.dart';
import 'package:pawpress/widgets/headerPages.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/screens/OwnerProfile.dart';

class MarketPlacePage extends StatefulWidget {
  final String pageTitle;
  final petOwner owner;

  const MarketPlacePage({
    super.key,
    required this.pageTitle,
    required this.owner,
  });

  @override
  State<MarketPlacePage> createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OwnerProfileScreen(owner: widget.owner),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(owner: widget.owner),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  final List<String> categories = ['Food', 'Toys', 'Accessories', 'Medicine'];

  final List<Product> popularProducts = [
    Product(
      productId: 1,
      productName: 'Cat Food',
      price: 12.0,
      description: 'Nutritious food for cats.',
      quantity: 10,
      imagePath: 'assets/catFood.png',
    ),
    Product(
      productId: 2,
      productName: 'Dog Toy',
      price: 8.0,
      description: 'Durable rubber toy for dogs.',
      quantity: 15,
      imagePath: 'assets/dogToy.png',
    ),
    Product(
      productId: 3,
      productName: 'Bird Cage',
      price: 30.0,
      description: 'Spacious cage for birds.',
      quantity: 5,
      imagePath: 'assets/Bird.png',
    ),
    Product(
      productId: 4,
      productName: 'Fish Medicine',
      price: 5.0,
      description: 'Anti-bacterial treatment for fish.',
      quantity: 20,
      imagePath: 'assets/Fish.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(pageTitle: widget.pageTitle),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C4966),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Chip(
                      label: Text(categories[index]),
                      backgroundColor: const Color(0xFFE7F6EF),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Popular Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C4966),
                  ),
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: popularProducts.length,
                itemBuilder: (context, index) {
                  final product = popularProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: product,
                            owner: widget.owner,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: const Color(0xFFFFF9E6),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                product.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFF1C7259),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.productName} added to cart!',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
