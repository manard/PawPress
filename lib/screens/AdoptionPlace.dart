import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawpress/api_config.dart';
import 'package:pawpress/screens/AdoptionScreen.dart';

class AdoptionPlace extends StatefulWidget {
  const AdoptionPlace({Key? key}) : super(key: key);

  @override
  _AdoptionPlaceState createState() => _AdoptionPlaceState();
}

class _AdoptionPlaceState extends State<AdoptionPlace> {
  List<dynamic> adoptionData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdoptionData();
  }

  Future<void> _fetchAdoptionData() async {
    final url = Uri.parse('${ApiConfig.baseURL}/adoptionplace');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          adoptionData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch adoption data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching adoption data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Soft pink background
      appBar: AppBar(
        title: const Text(
          'Adoption Centers',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.pink[300], // Pink app bar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: adoptionData.length,
                itemBuilder: (context, index) {
                  final adoption = adoptionData[index];
                  return _buildFullWidthPetCard(adoption, context);
                },
              ),
    );
  }

  Widget _buildFullWidthPetCard(
    Map<String, dynamic> adoption,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.pink[100], // Light pink card background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdoptionScreen(petID: adoption['petID']),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      Colors
                          .pink[200], // Slightly darker pink for image container
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        '${ApiConfig.baseURL}/${adoption['image']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pink[400]!,
                              ),
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.pink[400],
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // Info Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adoption['petName']?.toString().toUpperCase() ??
                          'UNKNOWN PET',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800], // Dark pink for pet name
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.pink[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Posted by: ${adoption['userName'] ?? 'Unknown User'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Status Section
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.pink[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Status: ${adoption['status'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
