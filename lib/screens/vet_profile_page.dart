import 'package:flutter/material.dart';
import 'package:pawpress/models/veterinarian.dart';

class VetProfilePage extends StatelessWidget {
  final Veterinarian vet;

  const VetProfilePage({super.key, required this.vet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinarian Profile'),
        backgroundColor: Color(0xFF096ECE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: Dr. ${vet.username}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Email: ${vet.email}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Phone: ${vet.phoneNumber}", style: TextStyle(fontSize: 16)),
            // Add more fields if needed
          ],
        ),
      ),
    );
  }
}
