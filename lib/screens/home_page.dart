import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/models/appointment.dart';
import 'package:pawpress/models/Pet.dart';
import 'package:pawpress/screens/MarketPlacePage.dart';
import 'package:pawpress/screens/NearbyVets.dart';
import 'package:pawpress/screens/Store.dart';
import 'package:pawpress/widgets/header_widget.dart';
import 'package:pawpress/widgets/bottom_nav.dart';
import 'package:pawpress/screens/OwnerProfile.dart';
import 'package:pawpress/screens/AdoptionPlace.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawpress/api_config.dart';
import 'package:pawpress/screens/PetDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  final petOwner owner;

  const HomeScreen({super.key, required this.owner});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // for bottom navigation

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerProfile(owner: widget.owner),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(owner: widget.owner),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    StorePage(userID: widget.owner.userID, owner: widget.owner),
          ),
        );
        break;
    }
  }

  final List<Appointment> appointments = [
    Appointment(
      id: "1",
      petName: "Suzy",
      appointmentDate: DateTime(2025, 6, 21, 12, 15),
      vetName: "Dr. Smith",
      reason: "Grooming",
    ),
    Appointment(
      id: "2",
      petName: "Bob",
      appointmentDate: DateTime(2025, 6, 27, 12, 15),
      vetName: "Dr. Alex",
      reason: "Rabies Vaccine",
    ),
  ];

  Future<List<Pet>> _fetchPets() async {
    final url = Uri.parse('${ApiConfig.baseURL}/getpets');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userID': widget.owner.userID}),
      );
      print("USERID ${widget.owner.userID}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((petJson) => Pet.fromJson(petJson)).toList();
      } else {
        print('Failed to fetch pets: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching pets: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(owner: widget.owner),
            const SizedBox(height: 20),
            // My Pets Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "My Pets",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D3B6E),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 15),
            FutureBuilder<List<Pet>>(
              future: _fetchPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching pets'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No pets found'));
                }

                final pets = snapshot.data!;
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      final borderColor = Color(0xFFb392ac).withOpacity(0.8);

                      return GestureDetector(
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
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 90,
                          child: Column(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    '${ApiConfig.baseURL}/${pet.image.replaceAll("\\", "/")}',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.pets,
                                          size: 50,
                                          color: Color(0xFF5D3B6E),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pet.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5D3B6E),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10), // Reduced space
            // Services Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),

              // Reduced bottom padding
              child: Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D3B6E),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            _buildServicesGrid(), // Moved closer
            const SizedBox(height: 20),
            // Appointments Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Upcoming Appointments",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D3B6E),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildAppointmentsList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildServiceCard(
            icon: Icons.shopping_basket_rounded,
            title: 'MarketPlace',
            iconColor: Color(0xFF9C27B0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MarketPlacePage(
                        pageTitle: 'MarketPlace',
                        owner: widget.owner,
                      ),
                ),
              );
            },
          ),
          _buildServiceCard(
            icon: Icons.people_alt_rounded,
            title: 'Community',
            iconColor: Color(0xFF2196F3),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdoptionPlace()),
              );
            },
          ),
          _buildServiceCard(
            icon: Icons.medical_services_rounded,
            title: 'Vet Clinics',
            iconColor: Color(0xFFF44336),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NearbyVetsScreen()),
              );
            },
          ),
          _buildServiceCard(
            icon: Icons.assignment_rounded,
            title: 'Medical Report',
            iconColor: Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 5,
              offset: Offset(0, 4), // ظل خفيف من الأسفل
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.1),
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return Column(
      children: appointments.map((app) => _buildAppointmentCard(app)).toList(),
    );
  }

  Widget _buildAppointmentCard(Appointment app) {
    DateTime now = DateTime.now();
    bool isToday =
        app.appointmentDate.day == now.day &&
        app.appointmentDate.month == now.month &&
        app.appointmentDate.year == now.year;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    app.reason,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D3B6E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "For ${app.petName}",
              style: TextStyle(
                color: Color(0xFF5D3B6E).withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Color(0xFF5D3B6E)),
                const SizedBox(width: 8),
                Text(
                  "${app.appointmentDate.day}/${app.appointmentDate.month}/${app.appointmentDate.year}",
                  style: TextStyle(color: Color(0xFF5D3B6E)),
                ),
                const SizedBox(width: 15),
                Icon(Icons.access_time, size: 18, color: Color(0xFF5D3B6E)),
                const SizedBox(width: 8),
                Text(
                  "${app.appointmentDate.hour}:${app.appointmentDate.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(color: Color(0xFF5D3B6E)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFb392ac)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        color: Color(0xFF5D3B6E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFb392ac),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 3,
                    ),
                    child: Text(
                      "Complete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
