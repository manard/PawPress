import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/models/Pet.dart';
import 'package:pawpress/screens/EditOwnerProfile.dart';
import 'package:pawpress/screens/AddPet.dart';
import 'package:pawpress/screens/PetDetailsScreen.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawpress/api_config.dart';

class OwnerProfile extends StatefulWidget {
  final petOwner owner;
  const OwnerProfile({super.key, required this.owner});

  @override
  State<OwnerProfile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OwnerProfile> {
  int _currentIndex = 0;
  final Random _random = Random();
  List<Color> _petBorderColors = [];
  List<Pet> pets = [];
  bool _isLoadingPets = true;

  @override
  void initState() {
    super.initState();
    _generateRandomLightColors();
    _fetchPets();
  }

  void _generateRandomLightColors() {
    _petBorderColors = List.generate(5, (index) => _getRandomLightColor());
  }

  Color _getRandomLightColor() {
    return Color.fromRGBO(
      150 + _random.nextInt(100),
      150 + _random.nextInt(100),
      150 + _random.nextInt(100),
      1,
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(owner: widget.owner),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Scaffold(
                appBar: AppBar(title: const Text('Store')),
                body: const Center(child: Text('Store Screen Coming Soon!')),
              ),
        ),
      );
    }
    setState(() => _currentIndex = index);
  }

  Widget _petAvatar(Pet pet, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PetDetailsScreen(
                        petId: pet.petID,
                        userId: widget.owner.userID,
                      ),
                ),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 3),
              ),
              child: ClipOval(
                child:
                    pet.image.isNotEmpty
                        ? Image.network(
                          'http://localhost:3000/${pet.image!.replaceAll("\\", "/")}',
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.pets,
                                size: 40,
                                color: Colors.grey,
                              ),
                        )
                        : const Icon(Icons.pets, size: 40, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            pet.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchPets() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/getpets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userID': widget.owner.userID}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          pets = data.map((petJson) => Pet.fromJson(petJson)).toList();
          _isLoadingPets = false;
        });
      }
    } catch (e) {
      print('Error fetching pets: $e');
      setState(() => _isLoadingPets = false);
    }
  }

  Widget _buildPetsList() {
    return SizedBox(
      height: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Add Pet Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPet()),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[100],
                      border: Border.all(color: Colors.blue, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.blue, size: 30),
                  ),
                ),

                // Pets List
                if (pets.isNotEmpty)
                  ...pets.map(
                    (pet) => Align(
                      alignment: Alignment.center,
                      child: _petAvatar(
                        pet,
                        _petBorderColors[pets.indexOf(pet) %
                            _petBorderColors.length],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.person, "Username", widget.owner.username),
          const Divider(height: 30, thickness: 0.5),
          _buildInfoRow(Icons.email, "Email", widget.owner.email),
          const Divider(height: 30, thickness: 0.5),
          _buildInfoRow(Icons.phone, "Phone", widget.owner.phoneNumber),
          const Divider(height: 30, thickness: 0.5),
          _buildInfoRow(Icons.location_on, "Address", widget.owner.address),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue[300], size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[400]!, Colors.blue[200]!],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/profile.png",
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.owner.username,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 24,
                    child: FloatingActionButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditProfileScreen(user: widget.owner),
                            ),
                          ),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      mini: true,
                      child: Icon(
                        Icons.edit,
                        color: Colors.blue[400],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // My Pets Section (kept exactly as original)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Pets",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  if (pets.isNotEmpty)
                    Text(
                      "${pets.length} Pets",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildPetsList(), // Original pets list implementation
            const SizedBox(height: 30),

            // Modernized Profile Info
            _buildProfileInfoCard(),
            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Logout functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      // Delete account functionality
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[400],
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: Colors.red[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
        ],
      ),
    );
  }
}
