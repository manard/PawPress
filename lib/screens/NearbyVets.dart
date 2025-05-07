import 'package:flutter/material.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';
import 'package:pawpress/widgets/top_nav_services.dart';

class NearbyVetsScreen extends StatelessWidget {
  const NearbyVetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        children: [
          // Background map image
          Positioned.fill(
            child: Image.asset(
              'assets/mapImage.jpeg', // Make sure this image exists in your assets
              fit: BoxFit.cover,
            ),
          ),

          // Top bar (extracted widget)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBarServices(title: 'Nearby Vets'),
          ),

          // Paw print markers on map
          ...[
            const Offset(150, 220),
            const Offset(240, 290),
            const Offset(100, 310),
            const Offset(160, 430),
            const Offset(280, 470),
            const Offset(220, 540),
          ].map((offset) => Positioned(
                top: offset.dy,
                left: offset.dx,
                child: Image.asset(
                  'assets/paw.png', // Make sure this image exists in your assets
                  width: 40,
                  height: 40,
                ),
              )),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            // Navigate to Profile Screen
          } else if (index == 1) {
            // Stay on this screen
          } else if (index == 2) {
            // Navigate to Store Screen
          }
        },
      ),
    );
  }
}
