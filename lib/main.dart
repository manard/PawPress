import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/screens/OrderSuccessScreen.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/screens/OwnerProfile.dart';
//import 'package:pawpress/widgets/bottom_nav_bar.dart';
import 'package:pawpress/screens/Welcome.dart';
import 'package:pawpress/screens/AdoptionScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
      routes: {
        '/adoption': (context) {
          final petID = ModalRoute.of(context)!.settings.arguments as int;
          return AdoptionScreen(petID: petID);
        },
        '/order-success': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args == null || args is! petOwner) {
            return Scaffold(
              body: Center(child: Text('No owner data provided')),
            );
          }
          return OrderSuccessScreen(owner: args);
        },
      },
    );
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
          // Add more items as needed
        ],
      ),
    );
  }
}
