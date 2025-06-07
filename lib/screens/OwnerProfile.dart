import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/models/Pet.dart';
import 'package:pawpress/screens/EditOwnerProfile.dart';
import 'package:pawpress/screens/AddPet.dart';
import 'package:pawpress/screens/PetDetailsScreen.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';

class OwnerProfile extends StatefulWidget {
  final petOwner owner;
  const OwnerProfile({super.key, required this.owner});

  @override
  State<OwnerProfile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OwnerProfile> {
  Map<String, bool> isExpanded = {
    'username': false,
    'email': false,
    'password': false,
    'phone': false,
    'address': false,
  };

  int _currentIndex = 0;
  final Random _random = Random();
  List<Color> _petBorderColors = [];

  @override
  void initState() {
    super.initState();
    _generateRandomLightColors();
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
    setState(() {
      _currentIndex = index;
    });
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
                  builder: (context) => PetDetailsScreen(pet: pet),
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
                child: Image.asset(
                  pet.image,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.pets, size: 40, color: Colors.grey),
                ),
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

  Widget _buildPetsList() {
    List<Pet> pets = widget.owner.pets;

    // إذا القائمة فاضية، نضيف حيوانات وهمية للتجربة
    if (pets.isEmpty) {
      pets = [
        Pet(
          name: "Bella",
          image: "assets/cat1.png",
          petID: 1,
          ownerID: 1,
          age: 1,
          breed: 'dd',
          gender: 'f',
        ),
        Pet(
          name: "Suzy",
          image: "assets/cat1.png",
          petID: 1,
          ownerID: 1,
          age: 1,
          breed: 'dd',
          gender: 'f',
        ),
      ];
    }

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // زر الإضافة
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPet(owner: widget.owner),
                ),
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
              ),
              child: const Icon(Icons.add, color: Colors.blue, size: 30),
            ),
          ),

          // عرض الحيوانات
          ...pets.map(
            (pet) => _petAvatar(
              pet,
              _petBorderColors[pets.indexOf(pet) % _petBorderColors.length],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpandableField(
    IconData icon,
    String label,
    String value,
    String keyName,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black45),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded[keyName]!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded[keyName] = !(isExpanded[keyName] ?? false);
                    });
                  },
                ),
              ],
            ),
          ),
          if (isExpanded[keyName] == true) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 120, 179, 224),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 50,

                            backgroundImage: AssetImage("assets/profile.png"),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.owner.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EditProfileScreen(user: widget.owner),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                    ),
                    child: const Text(
                      "Edit profile",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
                  if (widget.owner.pets.isNotEmpty)
                    Text(
                      "${widget.owner.pets.length} Pets",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildPetsList(),
            const SizedBox(height: 20),
            buildExpandableField(
              Icons.person,
              "User Name",
              widget.owner.username,
              'username',
            ),
            buildExpandableField(
              Icons.email,
              "Email",
              widget.owner.email,
              'email',
            ),
            buildExpandableField(
              Icons.lock,
              "Password",
              "********",
              'password',
            ),
            buildExpandableField(
              Icons.phone,
              "Mobile Number",
              widget.owner.phoneNumber,
              'phone',
            ),
            buildExpandableField(
              Icons.location_on,
              "Address",
              widget.owner.address,
              'address',
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add log out functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Log out",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Delete account functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
