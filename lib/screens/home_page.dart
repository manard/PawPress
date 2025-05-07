import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/models/appointment.dart';
import 'package:pawpress/screens/MarketPlacePage.dart';
import 'package:pawpress/screens/NearbyVets.dart';
import 'package:pawpress/widgets/header_widget.dart';
import 'package:pawpress/widgets/service_card.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';
import 'package:pawpress/screens/OwnerProfile.dart';

class HomeScreen extends StatefulWidget {
  final petOwner owner;

  const HomeScreen({super.key, required this.owner});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OwnerProfileScreen(owner: widget.owner),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
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
      reason: "Rabies",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(owner: widget.owner),
            const SizedBox(height: 20),
            sectionTitle("My Pets"),
            const SizedBox(height: 10),
            buildPetsList(),
            const SizedBox(height: 20),
            sectionTitle("Our Services"),
            const SizedBox(height: 10),
            buildServicesList(),
            const SizedBox(height: 20),
            sectionTitle("Upcoming Reminders"),
            const SizedBox(height: 10),
            buildAppointmentsList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C4966), // أزرق داكن أنيق
        ),
      ),
    );
  }

  Widget buildPetsList() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          petAvatar("Caramel"),
          petAvatar("Beth"),
          petAvatar("Ahmad"),
          petAvatar("Max"),
          petAvatar("Rex"),
        ],
      ),
    );
  }

  Widget buildServicesList() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          ServiceCard(
            icon: Icons.store,
            serviceName: 'MarketPlace',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MarketPlacePage(
                        owner: widget.owner,
                        pageTitle: 'MarketPlace',
                      ),
                ),
              );
            },
          ),
          ServiceCard(icon: Icons.people, serviceName: 'Community'),
          ServiceCard(
            icon: Icons.local_hospital,
            serviceName: 'Vet Clinics',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NearbyVetsScreen()),
              );
            },
          ),
          ServiceCard(icon: Icons.description, serviceName: 'Medical Report'),
        ],
      ),
    );
  }

  Widget buildAppointmentsList() {
    return Column(
      children: appointments.map((app) => buildAppointmentCard(app)).toList(),
    );
  }

  Widget buildAppointmentCard(Appointment app) {
    DateTime now = DateTime.now();

    bool isToday =
        app.appointmentDate.day == now.day &&
        app.appointmentDate.month == now.month &&
        app.appointmentDate.year == now.year;

    bool isThisWeek =
        app.appointmentDate.isAfter(now) &&
        app.appointmentDate.isBefore(now.add(const Duration(days: 7)));

    bool isThisMonth =
        app.appointmentDate.month == now.month &&
        app.appointmentDate.year == now.year;

    String label = "";
    if (isToday) {
      label = "Today";
    } else if (isThisWeek) {
      label = "This Week";
    } else if (isThisMonth) {
      label = "This Month";
    } else {
      label = "Later";
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: const Color(0xFFE7F6EF), // أخضر فاتح
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    app.reason,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C7259), // أخضر جميل
                    ),
                  ),
                ),
                if (label.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF88C9BF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${app.petName} ${formatDateTime(app.appointmentDate)}",
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text("Complete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C7259),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.remove_red_eye),
                    label: const Text("View"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C7259),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.month}/${dateTime.day}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(200),
      random.nextInt(200),
      random.nextInt(200),
      1,
    );
  }

  Widget petAvatar(String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: getRandomColor(),
            backgroundImage: const AssetImage('assets/cat1.png'),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
