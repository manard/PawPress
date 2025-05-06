import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/screens/EditOwnerProfile.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';

class OwnerProfileScreen extends StatefulWidget {
  final petOwner owner;
  const OwnerProfileScreen({super.key, required this.owner});

  @override
  State<OwnerProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OwnerProfileScreen> {
  Map<String, bool> isExpanded = {
    'username': false,
    'email': false,
    'password': false,
    'phone': false,
    'address': false,
  };

  List<Color> petColors = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    generateRandomColors();
  }

  void generateRandomColors() {
    Random random = Random();
    petColors = List.generate(
      5,
      (index) => Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(owner: widget.owner),
        ),
      );
    } else if (index == 2) {
      // Go to Store
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
    // If index is 0 (Profile), stay on current page
    setState(() {
      _currentIndex = index;
    });
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
                          CircleAvatar(
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
                children: const [
                  Text(
                    "My Pets",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildAddPetButton(petColors[0]),
                  buildPetImage('assets/cat1.png', petColors[1]),
                  buildPetImage('assets/cat1.png', petColors[2]),
                  buildPetImage('assets/cat1.png', petColors[3]),
                  buildPetImage('assets/cat1.png', petColors[4]),
                ],
              ),
            ),
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
              widget.owner.phoneNumber.toString(),
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

  Widget buildPetImage(String imagePath, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 70,
      height: 70,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget buildAddPetButton(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 70,
      height: 70,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const Icon(Icons.add, size: 36, color: Colors.white),
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
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black26,
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
}
