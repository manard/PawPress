import 'package:flutter/material.dart';
import 'package:pawpress/widgets/bottom_nav_bar.dart';
import 'package:pawpress/screens/Welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Welcome());
  }
}

class MainPage extends StatefulWidget {
  //final petOwner owner;
  const MainPage({super.key});

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
      //OwnerProfileScreen(owner: widget.owner),
      // HomeScreen(owner: widget.owner),
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
