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
  final TextEditingController otherSpecializationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Validation flags
  bool _firstNameValid = true;
  bool _lastNameValid = true;
  bool _emailValid = true;
  bool _phoneValid = true;
  bool _addressValid = true;
  bool _specializationValid = true;
  bool _otherSpecializationValid = true;
  bool _passwordValid = true;
  bool _showOtherSpecialization = false;

  final List<String> specializations = [
    'Small Animal Medicine',
    'Large Animal Medicine',
    'Exotic Animal Medicine',
    'Equine Medicine',
    'Internal Medicine',
    'Surgery',
    'Dermatology',
    'Dentistry',
    'Ophthalmology',
    'Anesthesiology',
    'Radiology (Diagnostic Imaging)',
    'Emergency and Critical Care',
    'Preventive Medicine',
    'Behavior',
    'Nutrition',
    'Reproduction (Theriogenology)',
    'Wildlife/Zoo Medicine',
    'Public Health',
    'Alternative Medicine',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
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
    
    if (text.isEmpty) {
      usernameController.text = 'vet';
      usernameController.selection = TextSelection.collapsed(offset: 3);
      return;
    }
    
    if (!text.startsWith('vet')) {
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

  bool _validateFields() {
    bool isValid = true;
    
    // Name validation (only letters)
    final nameRegex = RegExp(r'^[a-zA-Z]+$');
    _firstNameValid = nameRegex.hasMatch(firstNameController.text.trim());
    _lastNameValid = nameRegex.hasMatch(lastNameController.text.trim());
    
    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    _emailValid = emailRegex.hasMatch(emailController.text.trim());
    
    // Phone validation (only numbers)
    final phoneRegex = RegExp(r'^[0-9]+$');
    _phoneValid = phoneRegex.hasMatch(phoneController.text.trim());
    
    // Address validation (not empty)
    _addressValid = addressController.text.trim().isNotEmpty;
    
    // Specialization validation
    _specializationValid = specializationController.text.trim().isNotEmpty;
    
    // Password validation (min 6 characters)
    _passwordValid = passwordController.text.trim().length >= 6;
    
    // Other specialization validation if shown
    if (_showOtherSpecialization) {
      _otherSpecializationValid = otherSpecializationController.text.trim().isNotEmpty;
      if (!_otherSpecializationValid) isValid = false;
    }
    
    if (!_firstNameValid || 
        !_lastNameValid || 
        !_emailValid || 
        !_phoneValid || 
        !_addressValid || 
        !_specializationValid || 
        !_passwordValid) {
      isValid = false;
    }
    
    setState(() {});
    
    return isValid;
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

  Widget _buildSpecializationField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Specialization',
              style: TextStyle(
                color: Colors.black, 
                fontSize: 16,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              errorText: !_specializationValid ? 'Please select a specialization' : null,
            ),
            value: specializationController.text.isEmpty ? null : specializationController.text,
            items: specializations.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                specializationController.text = newValue ?? '';
                _showOtherSpecialization = newValue == 'Other';
                if (!_showOtherSpecialization) {
                  otherSpecializationController.clear();
                }
                _otherSpecializationValid = true;
              });
            },
            hint: const Text('Select Specialization'),
          ),
          if (_showOtherSpecialization)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Specify your specialization',
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: otherSpecializationController,
                    decoration: InputDecoration(
                      hintText: 'Enter your specialization',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorText: !_otherSpecializationValid ? 'Please specify your specialization' : null,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    bool? isValid,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey), 
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              errorText: (isValid != null && !isValid) ? errorText ?? 'Invalid input' : null,
            ),
          ),
        ],
      ),
    );
  }

  void signUpVet() async {
    if (!_validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please correct the errors in the form"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!usernameController.text.startsWith('vet') || usernameController.text.length <= 3) {
      setState(() => _usernameValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username must start with 'vet' and have additional characters"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    String finalSpecialization = specializationController.text;
    if (finalSpecialization == 'Other' && otherSpecializationController.text.isNotEmpty) {
      finalSpecialization = otherSpecializationController.text;
    }
    
    const url = 'http://localhost:3000/signupVet';
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
        'specialization': finalSpecialization,
        'password': passwordController.text,
        'role': 'vet',
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vet signed up successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign up failed: ${response.body}"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: firstNameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'First Name',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        errorText: !_firstNameValid ? 'Only alphabetic characters allowed' : null,
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
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: lastNameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'Last Name',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        errorText: !_lastNameValid ? 'Only alphabetic characters allowed' : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      _buildUsernameField(),

                      buildTextField(
                        'Email', 
                        emailController, 
                        isValid: _emailValid,
                        errorText: 'Please enter a valid email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      buildTextField(
                        'Phone Number', 
                        phoneController, 
                        isValid: _phoneValid,
                        errorText: 'Only numbers allowed',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      
                      buildTextField(
                        'Address', 
                        addressController, 
                        isValid: _addressValid,
                        errorText: 'Please enter your address',
                      ),
                      
                      _buildSpecializationField(),
                      
                      buildTextField(
                        'Password', 
                        passwordController, 
                        obscure: true, 
                        isValid: _passwordValid,
                        errorText: 'Password must be at least 6 characters',
                      ),

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