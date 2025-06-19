import 'package:flutter/material.dart';

class AddAdoptionPostPage extends StatefulWidget {
  const AddAdoptionPostPage({super.key});

  @override
  _AddAdoptionPostPageState createState() => _AddAdoptionPostPageState();
}

class _AddAdoptionPostPageState extends State<AddAdoptionPostPage> {
  final _formKey = GlobalKey<FormState>();
  String petName = '', breed = '', healthStatus = '';
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Adoption Post"),
        backgroundColor: Color(0xFF78B3E0),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(decoration: InputDecoration(labelText: 'Pet Name')),
              TextFormField(decoration: InputDecoration(labelText: 'Breed')),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Health Status'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF78B3E0),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add logic to save
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
