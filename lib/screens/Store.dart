import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpress/api_config.dart';
import 'dart:convert';
import 'package:pawpress/models/Cart.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/screens/checkoutWithPayPal.dart';

class StorePage extends StatefulWidget {
  final int userID;
  final petOwner owner; // Add petOwner parameter

  const StorePage({Key? key, required this.userID, required this.owner})
    : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late Future<List<Cart>> _cartItems;
  Set<int> selectedItems = {}; // store selected productIDs

  Future<List<Cart>> fetchCartData() async {
    final url = Uri.parse('${ApiConfig.baseURL}/getUserCart');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userID': widget.userID}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cart.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  Future<void> removeFromCart(int productID) async {
    final url = Uri.parse('${ApiConfig.baseURL}/removeFromCart');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userID': widget.userID, 'productID': productID}),
    );
    if (response.statusCode == 200) {
      setState(() {
        _cartItems = fetchCartData(); // refresh cart
        selectedItems.remove(productID);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to remove item')));
    }
  }

  void proceedToCheckout() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select items to checkout')),
      );
      return;
    }

    // Navigate to checkout page or handle checkout logic
    print('Proceeding to checkout for items: $selectedItems');
    // TODO: implement actual checkout logic
  }

  @override
  void initState() {
    super.initState();
    _cartItems = fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: FutureBuilder<List<Cart>>(
        future: _cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          } else {
            final cartItems = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: selectedItems.contains(cartItem.productID),
                            onChanged: (isSelected) {
                              setState(() {
                                if (isSelected!) {
                                  selectedItems.add(cartItem.productID);
                                } else {
                                  selectedItems.remove(cartItem.productID);
                                }
                              });
                            },
                          ),
                          title: Text(cartItem.name),
                          subtitle: Text(
                            'Price: ${cartItem.price.toStringAsFixed(2)} USD\nQuantity: ${cartItem.quantity}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeFromCart(cartItem.productID),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    double totalPrice = 0;
                    for (var item in cartItems) {
                      if (selectedItems.contains(item.productID)) {
                        totalPrice += item.price * item.quantity;
                      }
                    }
                    checkoutWithPayPal(
                      context: context,
                      userID: widget.userID,
                      owner:
                          widget.owner, // Pass the petOwner instance directly
                      cartItems:
                          cartItems
                              .where(
                                (item) =>
                                    selectedItems.contains(item.productID),
                              )
                              .toList(),
                      totalPrice: totalPrice,
                    );
                  },
                  child: Text('Checkout with PayPal'),
                ),
                const SizedBox(height: 12),
              ],
            );
          }
        },
      ),
    );
  }
}
