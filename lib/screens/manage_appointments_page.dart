import 'package:flutter/material.dart';

class ManageAppointmentsPage extends StatelessWidget {
  const ManageAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Appointments"),
        backgroundColor: Color(0xFF78B3E0),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with real data
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.pets),
              title: Text("Pet Name ${index + 1}"),
              subtitle: Text("Owner: John Doe\nPurpose: Check-up"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.check), onPressed: () {}),
                  IconButton(icon: Icon(Icons.close), onPressed: () {}),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
