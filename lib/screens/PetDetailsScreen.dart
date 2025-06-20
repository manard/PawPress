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

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  Map<String, dynamic>? petData;
  bool isLoading = true;
  bool isEditing = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  Map<String, dynamic>? currentUser;

  // Move ValueNotifier to a higher level
  final ValueNotifier<String> deliveryMethodNotifier = ValueNotifier<String>(
    '',
  );

  final TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchPetDetails();
    _fetchCurrentUser();
    _nameController = TextEditingController();
    _breedController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    deliveryMethodNotifier.dispose(); // Dispose the notifier
    locationController.dispose(); // Dispose the locationController
    super.dispose();
  }

  Future<void> _fetchPetDetails() async {
    final url = Uri.parse('http://localhost:3000/getpetdetails');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'petID': widget.petId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          petData = jsonDecode(response.body);
          _nameController.text = petData!['name'] ?? '';
          _breedController.text = petData!['breed'] ?? '';
          _ageController.text = petData!['age']?.toString() ?? '';
          _genderController.text = petData!['gender'] ?? '';
          isLoading = false;
        });
      } else {
        print('Failed to fetch pet details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching pet details: $e');
    }
  }

  Future<void> _fetchCurrentUser() async {
    final url = Uri.parse('http://localhost:3000/getuserdetails');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userID': widget.userId,
        }), // Use the correct userId from the widget
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          currentUser = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    // Implement your save logic here
    // You would typically send the updated data to your API
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _cancelEdit() {
    // Reset to original values
    _nameController.text = petData!['name'] ?? '';
    _breedController.text = petData!['breed'] ?? '';
    _ageController.text = petData!['age']?.toString() ?? '';
    _genderController.text = petData!['gender'] ?? '';
    _selectedImage = null;
    setState(() {
      isEditing = false;
    });
  }

  void _showAdoptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: deliveryMethodNotifier,
                builder: (context, deliveryMethod, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              deliveryMethodNotifier.value = 'Delivery';
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  deliveryMethod == 'Delivery'
                                      ? Colors.blue
                                      : Colors.grey[300],
                            ),
                            child: const Text('Delivery'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              deliveryMethodNotifier.value = 'Meet in Person';
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  deliveryMethod == 'Meet in Person'
                                      ? Colors.blue
                                      : Colors.grey[300],
                            ),
                            child: const Text('Meet in Person'),
                          ),
                        ],
                      ),
                      if (deliveryMethod == 'Meet in Person') ...[
                        TextField(
                          controller: locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(), // Disable past dates
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                      : 'Select Date',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse('http://localhost:3000/adoption');
                  try {
                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'userID': widget.userId,
                        'petID': widget.petId,
                        'delivery_method': deliveryMethodNotifier.value,
                        'location': locationController.text,
                        'meeting_date':
                            selectedDate != null
                                ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                                : '',
                        'status': 'Available',
                      }),
                    );

                    // Print the data to ensure correctness
                    print('userID: ${widget.userId}');
                    print('petID: ${widget.petId}');
                    print('deliveryMethod: ${deliveryMethodNotifier.value}');
                    print('location: ${locationController.text}');
                    print(
                      'meetingDate: ${selectedDate != null ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}' : ''}',
                    );
                    print('status: Available');

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Adoption details saved successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      print(
                        'Failed to save adoption details: ${response.body}',
                      );
                    }
                  } catch (e) {
                    print('Error saving adoption details: $e');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToFoodTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodTracker(petID: widget.petId)),
    );
  }

  void _navigateToProductDetails(int productID, dynamic product, dynamic owner) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          productID: productID,
          product: product,
          owner: owner,
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              filled: true,
              fillColor: isEditing ? Colors.grey[100] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: title == 'Food Tracker' ? _navigateToFoodTracker : null,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 100,
          height: 120,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          if (!isLoading && petData != null)
            IconButton(
              icon: Icon(isEditing ? Icons.close : Icons.edit),
              onPressed: isEditing ? _cancelEdit : _toggleEdit,
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Image with edit option
                    Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child:
                                _selectedImage != null
                                    ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    )
                                    : petData!['image'] != null
                                    ? Image.network(
                                      'http://localhost:3000/${petData!['image']}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.pets, size: 60),
                                    )
                                    : const Icon(Icons.pets, size: 60),
                          ),
                        ),
                        if (isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cards Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCard(
                            'Pet Tracker',
                            Icons.location_on,
                            Colors.blue,
                          ),
                          _buildCard(
                            'Appointments',
                            Icons.calendar_today,
                            Colors.green,
                          ),
                          _buildCard(
                            'Food Tracker',
                            Icons.fastfood,
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),

                    // Pet details form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildEditableField('Pet Name', _nameController),
                          _buildEditableField('Breed', _breedController),
                          _buildEditableField('Age', _ageController),
                          _buildEditableField('Gender', _genderController),

                          // Health record (non-editable)
                          if (petData!['health_record_path'] != null &&
                              petData!['health_record_path'].isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Health Record',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.medical_services,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            petData!['health_record_path'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.download,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            // Implement download functionality
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    if (isEditing)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _showAdoptionBottomSheet, // Show the bottom sheet
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.blue.shade600),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Send to Adoption',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
    );
  }
}
