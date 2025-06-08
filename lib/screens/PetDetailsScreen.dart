import 'package:flutter/material.dart';
import 'package:pawpress/models/Pet.dart';

class PetDetailsScreen extends StatelessWidget {
  final Pet pet;

  PetDetailsScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: Center(child: Text('Pet details here')),
    );
  }
}
