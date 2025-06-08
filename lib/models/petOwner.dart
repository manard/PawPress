import 'package:pawpress/models/Pet.dart';

class petOwner {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String phoneNumber;
  // String imageName; //should be imageUrl for firbase
  String role;
  final List<Pet> pets;

  petOwner(
    this.pets, {
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    // required this.imageName,
    required this.role,
  });

  factory petOwner.fromJson(Map<String, dynamic> json) {
    var petsJson = json['pets'] as List<dynamic>? ?? [];
    List<Pet> petsList =
        petsJson.map((petJson) => Pet.fromJson(petJson)).toList();

    return petOwner(
      petsList,
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
