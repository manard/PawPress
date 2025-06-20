import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_selector/file_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpress/api_config.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {}
