import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpress/api_config.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:pawpress/screens/PaymentProcessingScreen.dart'; // تأكدي من الاستيراد

Future<void> checkoutWithPayPal({
  required BuildContext context,
  required int userID,
  required petOwner owner, // أضفنا هذا
  required List cartItems,
  required double totalPrice,
}) async {
  final url = Uri.parse('${ApiConfig.baseURL}/create-paypal-order');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'amount': totalPrice.toStringAsFixed(2),
      'return_url': 'myapp://paypal-success',
      'cancel_url': 'myapp://paypal-cancel',
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final paymentUrl = data['link'];

    print("## PayPal URL: $paymentUrl");

    // ✅ بعد فتح الرابط، ننتقل مباشرة لصفحة انتظار الدفع
    final launchSuccess = await launchUrlString(
      paymentUrl,
      mode: LaunchMode.externalApplication,
    );

    if (launchSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PaymentProcessingScreen(
                userID: userID,
                owner: owner,
                cartItems: cartItems,
                totalPrice: totalPrice,
              ),
        ),
      );
    } else {
      print("❌ Failed to launch PayPal URL");
    }
  } else {
    print("❌ Failed to initiate PayPal checkout");
    print("❌ Status Code: ${response.statusCode}");
    print("❌ Body: ${response.body}");
  }
}
