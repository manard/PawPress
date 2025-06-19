import 'package:flutter/material.dart';

class MedicalRecordsPage extends StatelessWidget {
  const MedicalRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Records"),
        backgroundColor: Color(0xFF78B3E0),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services),
              title: Text("Bella - Vaccination"),
              subtitle: Text("Date: 12 Mar 2025\nNotes: Annual shot"),
            ),
          ),
          // Add more records as needed
        ],
      ),
    );
  }
}
