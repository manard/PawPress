import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class NearbyVetsScreen extends StatefulWidget {
  const NearbyVetsScreen({Key? key}) : super(key: key);

  @override
  _NearbyVetsScreenState createState() => _NearbyVetsScreenState();
}

// Simple BottomNavBar widget implementation
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital),
          label: 'Vets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Store',
        ),
      ],
    );
  }
}

class _NearbyVetsScreenState extends State<NearbyVetsScreen> {
  double? latitude;
  double? longitude;
  List<Map<String, dynamic>> clinics = [];
  bool isLoading = true;

  final Distance distance = const Distance();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location permissions are denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      _fetchVeterinaryClinics();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchVeterinaryClinics() async {
    if (latitude == null || longitude == null) return;

    final overpassUrl = Uri.parse('https://overpass-api.de/api/interpreter');

    final query = """
      [out:json];
      (
        node["amenity"="veterinary"](around:5000,$latitude,$longitude);
        way["amenity"="veterinary"](around:5000,$latitude,$longitude);
        relation["amenity"="veterinary"](around:5000,$latitude,$longitude);
      );
      out center;
    """;

    try {
      final response = await http.post(
        overpassUrl,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'data': query},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<Map<String, dynamic>> results = [];
        for (var clinic in data['elements']) {
          final lat = clinic['lat'] ?? clinic['center']?['lat'];
          final lon = clinic['lon'] ?? clinic['center']?['lon'];
          if (lat != null && lon != null) {
            final double dist = distance.as(
              LengthUnit.Meter,
              LatLng(latitude!, longitude!),
              LatLng(lat, lon),
            );
            results.add({
              'lat': lat,
              'lon': lon,
              'name': clinic['tags']?['name'] ?? 'Unknown Veterinary Clinic',
              'distance': dist,
            });
          }
        }

        results.sort((a, b) => a['distance'].compareTo(b['distance']));

        setState(() {
          clinics = results;
          isLoading = false;
        });
      } else {
        print('Failed to fetch veterinary clinics: ${response.body}');
      }
    } catch (e) {
      print('Error fetching veterinary clinics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || latitude == null || longitude == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nearby Veterinary Clinics')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Veterinary Clinics')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(latitude!, longitude!),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    // 🟢 Marker for user's current location
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(latitude!, longitude!),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    // 🔴 Markers for veterinary clinics
                    ...clinics.map((clinic) {
                      return Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(clinic['lat'], clinic['lon']),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                return ListTile(
                  leading: const Icon(Icons.pets, color: Colors.red),
                  title: Text(clinic['name']),
                  subtitle: Text(
                    'Location: ${clinic['lat'].toStringAsFixed(5)}, ${clinic['lon'].toStringAsFixed(5)}\n'
                    'Distance: ${clinic['distance'].toStringAsFixed(0)} meters',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            // Navigate to Profile Screen
          } else if (index == 1) {
            // Stay on this screen
          } else if (index == 2) {
            // Navigate to Store Screen
          }
        },
      ),
    );
  }
}
