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
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OwnerProfile(owner: widget.owner),
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
      reason: "Rabies Vaccine",
    ),
  ];

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
            _sectionTitle("My Pets"),
            const SizedBox(height: 10),
            _buildPetsList(),
            const SizedBox(height: 5), // تم تقليل المسافة
            _sectionTitle("Our Services"),

            _buildServicesGrid(), // حُذفت المسافة السابقة هنا لتكون أقرب
            const SizedBox(height: 20),
            _sectionTitle("Upcoming Appointments"),
            const SizedBox(height: 10),
            _buildAppointmentsList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
    );
  }

  Widget _buildPetsList() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _petAvatar("Suzy", 'assets/cat1.png', _petBorderColors[0]),
          _petAvatar("Marry", 'assets/cat1.png', _petBorderColors[1]),
          _petAvatar("Bob", 'assets/cat1.png', _petBorderColors[2]),
          _petAvatar("Ruby", 'assets/cat1.png', _petBorderColors[3]),
          _petAvatar("Alice", 'assets/cat1.png', _petBorderColors[4]),
        ],
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
        childAspectRatio: 0.9,
        mainAxisSpacing: 10,
        crossAxisSpacing: 1,
        children: [
          service_card(
            iconWidget: Image.asset(
              'assets/online-shop.png',
              width: 60, // العرض
              height: 70, // الارتفاع
              fit: BoxFit.contain,
            ),
            serviceName: 'MarketPlace',
            color: const Color(0xFF3498DB),
            height: 160,
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
          service_card(
            iconWidget: Image.asset(
              'assets/online-shop.png',
              width: 60, // العرض
              height: 70, // الارتفاع
              fit: BoxFit.contain,
            ),
            serviceName: 'Community',
            color: const Color(0xFF2ECC71),
            height: 160,
          ),
          service_card(
            iconWidget: Image.asset(
              'assets/online-shop.png',
              width: 60, // العرض
              height: 70, // الارتفاع
              fit: BoxFit.contain,
            ),
            serviceName: 'Vet Clinics',
            color: const Color(0xFFE74C3C),
            height: 160,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NearbyVetsScreen()),
              );
            },
          ),
          service_card(
            iconWidget: Image.asset(
              'assets/online-shop.png',
              width: 60, // العرض
              height: 70, // الارتفاع
              fit: BoxFit.contain,
            ),
            serviceName: 'Medical Report',
            color: const Color(0xFF9B59B6),
            height: 160,
          ),
        ],
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
        color: const Color.fromARGB(255, 247, 230, 239),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
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
                Text(
                  app.reason,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE74C3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFE74C3C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "For ${app.petName}",
              style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 14),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF7F8C8D),
                ),
                const SizedBox(width: 5),
                Text(
                  "${app.appointmentDate.day}/${app.appointmentDate.month}/${app.appointmentDate.year}",
                  style: const TextStyle(color: Color(0xFF7F8C8D)),
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFF7F8C8D),
                ),
                const SizedBox(width: 5),
                Text(
                  "${app.appointmentDate.hour}:${app.appointmentDate.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Color(0xFF7F8C8D)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFe0b1cb)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        color: Color.fromARGB(255, 226, 172, 201),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      //
                      backgroundColor: const Color(0xFFe0b1cb),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Complete",
                      style: TextStyle(color: Colors.white),
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

  Widget _petAvatar(String name, String imagePath, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 3),
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 5),
          Text(
            name,
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
}
