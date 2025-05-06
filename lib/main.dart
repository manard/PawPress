import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/screens/OwnerProfile.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';
import 'package:pawpress/screens/Welcome.dart';

void main() {
  petOwner owner = petOwner(
    username: "Manar",
    email: "manar@gmail.com",
    password: "123",
    address: "qalandia",
    phoneNumber: 123456,
    imageName: 'assets/profile.png',
  );

  runApp(MyApp(owner: owner));
}

class MyApp extends StatelessWidget {
  final petOwner owner;
  const MyApp({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}

class MainPage extends StatefulWidget {
  final petOwner owner;
  const MainPage({super.key, required this.owner});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      OwnerProfileScreen(owner: widget.owner),
      HomeScreen(owner: widget.owner),
      Container(child: Center(child: Text('Store Screen Coming Soon!'))),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
