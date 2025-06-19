import 'package:flutter/material.dart';

class VetServiceCard extends StatelessWidget {
  final IconData icon;
  final String serviceName;
  final VoidCallback? onTap;

  const VetServiceCard({
    super.key,
    required this.icon,
    required this.serviceName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Card(
        color: Color(0xFFFFF9C4),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 150,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Color(0xFF096ECE)),
                SizedBox(height: 10),
                Text(
                  serviceName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF096ECE),
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