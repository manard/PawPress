import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawpress/api_config.dart';
import 'package:pawpress/models/petOwner.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final int userID;
  final List cartItems;
  final double totalPrice;
  final petOwner owner;

  const PaymentProcessingScreen({
    super.key,
    required this.userID,
    required this.cartItems,
    required this.totalPrice,
    required this.owner,
  });

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  late final AppLinks _appLinks;
  late final Stream<Uri> _uriStream;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    _appLinks = AppLinks();

    // Listen for incoming deep links
    _uriStream = _appLinks.uriLinkStream;
    _uriStream.listen((Uri uri) {
      if (uri.host == 'paypal-success') {
        _completeOrder();
      }
    });

    // Optional: Handle initial link if app already opened via PayPal
    final initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null && initialUri.host == 'paypal-success') {
      _completeOrder();
    }
  }

  Future<void> _completeOrder() async {
    final url = Uri.parse('${ApiConfig.baseURL}/complete-order');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': widget.userID,
        'totalPrice': widget.totalPrice,
        'cartItems':
            widget.cartItems
                .map(
                  (item) => {
                    'productID': item.productID,
                    'quantity': item.quantity,
                    'price': item.price,
                  },
                )
                .toList(),
      }),
    );
    print(
      "📦 Sending Order Body: ${jsonEncode({
        'userID': widget.userID,
        'totalPrice': widget.totalPrice,
        'cartItems': widget.cartItems.map((item) => {'productID': item.productID, 'quantity': item.quantity, 'price': item.price}).toList(),
      })}",
    );
    print("🔁 Status Code: ${response.statusCode}");
    print("🔁 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/order-success',
          arguments: widget.owner, // بعت الـ petOwner هنا
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save the order")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Waiting for payment confirmation from PayPal..."),
      ),
    );
  }
}
