import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:pawpress/screens/login.dart';

class SignUpVet extends StatefulWidget {
  const SignUpVet({super.key});

  @override
  State<SignUpVet> createState() => _SignUpVetState();
}

class _SignUpVetState extends State<SignUpVet> {
  bool _usernameValid = true;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with "vet" prefix
    usernameController.text = 'vet';
    usernameController.selection = TextSelection.collapsed(offset: 3);
    usernameController.addListener(_handleUsernameChanges);
  }

  @override
  void dispose() {
    usernameController.removeListener(_handleUsernameChanges);
    usernameController.dispose();
    super.dispose();
  }

  void _handleUsernameChanges() {
    final text = usernameController.text;
    
    // If user tries to delete the prefix completely
    if (text.isEmpty) {
      usernameController.text = 'vet';
      usernameController.selection = TextSelection.collapsed(offset: 3);
      return;
    }
    
    // If user tries to modify the prefix
    if (!text.startsWith('vet')) {
      // Get only the part after any existing "vet"
      final cleanText = text.substring(text.indexOf('vet') + 3);
      usernameController.text = 'vet$cleanText';
      usernameController.selection = TextSelection.collapsed(
        offset: usernameController.text.length
      );
    }
    
    setState(() {
      _usernameValid = usernameController.text.startsWith('vet') && 
                      usernameController.text.length > 3;
    });
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Username',
              style: TextStyle(
                color: Colors.black, 
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'vetusername',
              hintStyle: TextStyle(color: Colors.grey), 
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              errorText: _usernameValid ? null : 'Must start with "vet" and have additional characters',
            ),
          ),
        ],
      ),
    );
  }

  void signUpVet() async {
    const url = 'http://localhost:3000/signupVet';
    if (!usernameController.text.startsWith('vet') || usernameController.text.length <= 3) {
      setState(() => _usernameValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username must start with 'vet' and have additional characters")),
      );
      return;
    }
    
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'address': addressController.text,
        'specialization': specializationController.text,
        'password': passwordController.text,
        'role': 'vet',
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vet signed up successfully!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up failed: ${response.body}")),
      );
    }
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              hint,
              style: const TextStyle(
                color: Colors.black, 
                fontSize: 16,
              ),
            ),
          ),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey), 
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/couchguy.png', width: 230),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC3E2FF), Color(0xFFFFFFC3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Sign Up As Vet',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // First and Last Name in a Row
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'First Name',
                                        style: TextStyle(
                                          color: Colors.black, // Changed to black
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                        hintText: 'First Name',
                                        hintStyle: TextStyle(color: Colors.grey), // Added gray hint
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Last Name',
                                        style: TextStyle(
                                          color: Colors.black, // Changed to black
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Last Name',
                                        hintStyle: TextStyle(color: Colors.grey), // Added gray hint
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Use the custom username field
                      _buildUsernameField(),

                      buildTextField('Email', emailController),
                      buildTextField('Phone Number', phoneController),
                      buildTextField('Address', addressController),
                      buildTextField('Specialization', specializationController),
                      buildTextField('Password', passwordController, obscure: true),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: 280,
                        child: ElevatedButton(
                          onPressed: signUpVet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87C5FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: 280,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            side: const BorderSide(color: Colors.white),
                          ),
                          icon: Image.asset('assets/google.png', height: 24),
                          label: const Text(
                            'Sign Up with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}