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

  petOwner({
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
    return petOwner(
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      password: json['password'] ?? '',
      // imageName: json['imageName'],
      role: json['role'] ?? '',
    );
  }
}
