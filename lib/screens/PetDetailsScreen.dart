import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawpress/api_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pawpress/screens/FoodTracker.dart';
import 'package:pawpress/screens/ProductDetailsPage.dart'; // Import FoodTracker screen

class PetDetailsScreen extends StatefulWidget {
  final int petId;
  final int userId; // Add userId parameter

  const PetDetailsScreen({Key? key, required this.petId, required this.userId})
    : super(key: key);

  @override
  _PetDetailsScreenState createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {}
