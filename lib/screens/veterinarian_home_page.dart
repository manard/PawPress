import 'package:flutter/material.dart';
import 'package:pawpress/models/veterinarian.dart';
import 'package:pawpress/widgets/vet_header_widget.dart';
import 'package:pawpress/widgets/vet_service_card.dart';
import 'package:pawpress/widgets/vet_bottom_nav_bar.dart';
import 'package:pawpress/screens/manage_appointments_page.dart';
import 'package:pawpress/screens/add_adoption_post_page.dart';
import 'package:pawpress/screens/medical_records_page.dart';
import 'package:pawpress/screens/vet_profile_page.dart'; 

class VeterinarianHomePage extends StatefulWidget {
  final Veterinarian vet;

  const VeterinarianHomePage({super.key, required this.vet});

  @override
  _VeterinarianHomePageState createState() => _VeterinarianHomePageState();
}

class _VeterinarianHomePageState extends State<VeterinarianHomePage> {
  int _currentIndex = 1;

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map<String, String>> upcomingAppointments = [
    {
      'petName': 'Bella',
      'ownerName': 'Emily Johnson',
      'time': '10:00 AM, May 5',
    },
    {'petName': 'Max', 'ownerName': 'David Smith', 'time': '1:30 PM, May 5'},
    {'petName': 'Luna', 'ownerName': 'Sara Lee', 'time': '3:45 PM, May 5'},
  ];

  @override
  Widget build(BuildContext context) {
    // Define pages to show based on index
    final List<Widget> pages = [
      VetProfilePage(vet: widget.vet), // index 0
      _buildHomeContent(), // index 1
      Placeholder(), // index 2 (store page placeholder)
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: VetBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return ListView(
      children: [
        HeaderWidget(vet: widget.vet),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Your Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF096ECE),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ManageAppointmentsPage()),
                  );
                },
                child: VetServiceCard(
                  icon: Icons.calendar_today,
                  serviceName: 'Manage Appointments',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MedicalRecordsPage()),
                  );
                },
                child: VetServiceCard(
                  icon: Icons.pets,
                  serviceName: 'Medical Records',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddAdoptionPostPage()),
                  );
                },
                child: VetServiceCard(
                  icon: Icons.add_circle,
                  serviceName: 'Add Adoption Post',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Upcoming Appointments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF096ECE),
            ),
          ),
        ),
        ...upcomingAppointments.map(
          (appointment) => ListTile(
            leading: Icon(Icons.event_available, color: Color(0xFF78B3E0)),
            title: Text(
              '${appointment['petName']} - ${appointment['ownerName']}',
            ),
            subtitle: Text(appointment['time']!),
          ),
        ),
      ],
    );
  }
}
