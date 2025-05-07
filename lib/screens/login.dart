import 'package:flutter/material.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/screens/signupVet.dart';
import 'package:pawpress/screens/signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),

                // CouchGuy Image
                Image.asset('assets/couchguy.png', width: 250),

                const SizedBox(height: 10),

                // Card
                Expanded(
                  child: Container(
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

                          // Login Title
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Username Field
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Username',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Password Field
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          ElevatedButton(
                            onPressed: () {
                              petOwner owner = petOwner(
                                username: "Manar",
                                email: "manar@gmail.com",
                                password: "123",
                                address: "qalandia",
                                phoneNumber: 123456,
                                imageName: 'profile.png',
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => HomeScreen(owner: owner),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF87C5FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                              side: const BorderSide(color: Colors.white),
                            ),
                            icon: Image.asset('assets/google.png', height: 24),
                            label: const Text(
                              'Login with Google',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Sign Up text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final selectedRole = await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String? role;
                                      return AlertDialog(
                                        title: const Text('Sign up as'),
                                        content: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'Pet Owner',
                                                  ),
                                                  value: 'pet_owner',
                                                  groupValue: role,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      role = value;
                                                    });
                                                  },
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text('Vet'),
                                                  value: 'vet',
                                                  groupValue: role,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      role = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, null);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, role);
                                            },
                                            child: const Text('Continue'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (selectedRole != null) {
                                    if (selectedRole == 'pet_owner') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const SignUpPage(),
                                        ),
                                      );
                                    } else if (selectedRole == 'vet') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const SignUpVet(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  "Sign Up",
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
                ),
              ],
            ),

            // Skip button at top right
            Positioned(
              top: 10,
              right: 10,
              child: TextButton.icon(
                onPressed: () {
                  // بإمكانك تحطي نفس الحركة هنا لو حابة
                },
                icon: const Icon(Icons.arrow_right_alt, color: Colors.grey),
                label: const Text("Skip", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
