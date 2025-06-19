import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawpress/api_config.dart';

class AdoptionScreen extends StatefulWidget {
  final int petID;

  const AdoptionScreen({Key? key, required this.petID}) : super(key: key);

  @override
  _AdoptionScreenState createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  Map<String, dynamic>? adoptionDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdoptionDetails();
  }

  Future<void> _fetchAdoptionDetails() async {
    final url = Uri.parse('${ApiConfig.baseURL}/getAdoptionDetails');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'petID': widget.petID}),
      );

      if (response.statusCode == 200) {
        setState(() {
          adoptionDetails = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch adoption details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching adoption details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]!),
              ),
              SizedBox(height: 20),
              Text(
                'Loading pet details...',
                style: TextStyle(color: Colors.pink[300], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (adoptionDetails == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 60, color: Colors.pink[300]),
              SizedBox(height: 20),
              Text(
                'No adoption details found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final petName = adoptionDetails!['petName'] ?? 'Unknown';
    final breed = adoptionDetails!['breed'] ?? 'Unknown breed';
    final age = adoptionDetails!['age'] ?? 'Unknown age';
    final gender = adoptionDetails!['gender'] ?? 'Unknown';
    final imageUrl =
        adoptionDetails!['image'] != null
            ? '${ApiConfig.baseURL}/${adoptionDetails!['image']}'
            : null;

    final ownerName =
        '${adoptionDetails!['ownerFirstName'] ?? ''} ${adoptionDetails!['ownerLastName'] ?? ''}'
            .trim();
    final email = adoptionDetails!['ownerEmail'] ?? 'No email provided';
    final phone = adoptionDetails!['ownerPhoneNumber'] ?? 'No phone provided';

    final location = adoptionDetails!['location'] ?? 'Location not specified';
    final deliveryMethod =
        adoptionDetails!['delivery_method'] ?? 'Not specified';
    final date = adoptionDetails!['meeting_date'] ?? 'Date not set';
    final healthRecordPath =
        adoptionDetails!['healthRecordPath'] ?? 'No health record available';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Meet $petName', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Pet Image Header
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.pink[300]!, Colors.pink[200]!],
                ),
              ),
              child:
                  imageUrl != null
                      ? Hero(
                        tag: 'pet-image-${widget.petID}',
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.pets,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                      )
                      : Center(
                        child: Icon(Icons.pets, size: 80, color: Colors.white),
                      ),
            ),

            // Pet Details Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About $petName',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(Icons.pets, 'Breed', breed),
                      _buildDetailRow(Icons.cake, 'Age', '$age years'),
                      _buildDetailRow(
                        gender.toLowerCase() == 'male'
                            ? Icons.male
                            : Icons.female,
                        'Gender',
                        gender,
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                      Text(
                        'Adoption Arrangements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.location_on, 'Location', location),
                      _buildDetailRow(
                        Icons.delivery_dining,
                        'Delivery Method',
                        deliveryMethod,
                      ),
                      _buildDetailRow(
                        Icons.calendar_today,
                        'Meeting Date',
                        date,
                      ),
                      _buildDetailRow(
                        Icons.folder,
                        'Health Record',
                        healthRecordPath,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Owner Contact Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Owner',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                      ),
                      SizedBox(height: 16),
                      if (ownerName.isNotEmpty)
                        _buildDetailRow(Icons.person, 'Name', ownerName),
                      _buildDetailRow(Icons.email, 'Email', email),
                      _buildDetailRow(Icons.phone, 'Phone', phone),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.favorite_border),
                          label: Text('Confirm Adoption'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          onPressed: () {
                            _showConfirmationDialog(context, petName);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.pink[300]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String petName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Confirm Adoption'),
            content: Text('Are you sure you want to adopt $petName?'),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Adoption request sent for $petName!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }
}
