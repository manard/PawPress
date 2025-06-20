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

class _AddPetState extends State<AddPet> {
  final _formKey = GlobalKey<FormState>();

  String? name, breed, gender;
  int? age;
  File? image;
  XFile? health_record_path;
  int? userID;

  final List<String> genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _loaduserID();
  }

  Future<void> _loaduserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt('userID');
    });
  }

  Future<void> pickPetImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> pickHealthRecord() async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'Documents',
      extensions: ['pdf', 'jpg', 'png'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null) {
      setState(() {
        health_record_path = file;
      });
    }
  }

  void savePet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConfig.baseURL}/addpet'),
        );

        request.fields['name'] = name!;
        request.fields['age'] = age.toString();
        request.fields['gender'] = gender!;
        request.fields['breed'] = breed!;
        request.fields['userID'] =
            userID.toString(); // Updated to match the database column name

        if (image != null) {
          request.files.add(
            await http.MultipartFile.fromPath('image', image!.path),
          );
        }

        if (health_record_path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'health_record_path',
              health_record_path!.path,
            ),
          );
        }

        print('Request fields: ${request.fields}');
        print(
          'Request files: ${request.files.map((file) => file.field + ": " + (file.filename ?? "no filename")).toList()}',
        );
        print('Request URL: ${request.url}');

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        print('Response status: ${response.statusCode}');
        print('Response body: $responseBody');

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pet added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add pet: $responseBody'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Pet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade300, Colors.pink.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pet Image
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.pink.shade200,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            image != null
                                ? Image.file(image!, fit: BoxFit.cover)
                                : Container(
                                  color: Colors.grey.shade100,
                                  child: Icon(
                                    Icons.pets,
                                    size: 50,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickPetImage,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form Fields
              _buildTextField('Name', Icons.pets, (val) => name = val),
              const SizedBox(height: 16),

              _buildNumberField(
                'Age',
                Icons.cake,
                (val) => age = int.tryParse(val ?? ''),
              ),
              const SizedBox(height: 16),

              _buildDropdownField('Gender', Icons.transgender),
              const SizedBox(height: 16),

              _buildTextField('Breed', Icons.category, (val) => breed = val),
              const SizedBox(height: 24),

              // Health Record
              Text(
                'Health Records',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: pickHealthRecord,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.pink.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_file, color: Colors.pink.shade400),
                    SizedBox(width: 8),
                    Text(
                      'Upload Health Record',
                      style: TextStyle(color: Colors.pink.shade400),
                    ),
                  ],
                ),
              ),

              if (health_record_path != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Selected: ${health_record_path!.name}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 32),

              // Buttons
              ElevatedButton(
                onPressed: savePet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Save Pet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    Function(String?) onSaved,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.pink.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onSaved: onSaved,
      validator:
          (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildNumberField(
    String label,
    IconData icon,
    Function(String?) onSaved,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.pink.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: TextInputType.number,
      onSaved: onSaved,
      validator:
          (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDropdownField(String label, IconData icon) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.pink.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items:
          genderOptions
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
      onChanged: (val) => setState(() => gender = val),
      onSaved: (val) => gender = val,
      validator: (val) => val == null ? 'Please select $label' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.pink.shade300),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
