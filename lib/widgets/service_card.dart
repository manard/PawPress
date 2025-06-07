import 'package:flutter/material.dart';

class service_card extends StatelessWidget {
  final Widget iconWidget;
  final String serviceName;
  final VoidCallback? onTap;
  final Color color;
  final int height;

  const service_card({
    super.key,
    required this.iconWidget,
    required this.serviceName,
    required this.color,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // استخدمنا الـ Widget بدل الأيقونة العادية
                iconWidget,
                const SizedBox(height: 10),
                Text(
                  serviceName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFe0b1cb),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
