import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String serviceName;
  final VoidCallback? onTap;
  const ServiceCard({
    super.key,
    required this.icon,
    required this.serviceName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: const Color(0xFFFFFDE7), 
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Color.fromARGB(255, 232, 205, 140)), 
                const SizedBox(height: 10),
                Text(
                  serviceName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:Color.fromARGB(255, 232, 205, 140),
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
