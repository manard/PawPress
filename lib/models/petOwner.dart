class petOwner {
  final String username;
  final String email;
  final String password;
  final String address;
  final int phoneNumber;
  String imageName;//should be imageUrl for firbase

  petOwner({
    required this.username,
    required this.email,
    required this.password,
    required this.address,
    required this.phoneNumber,
    required this.imageName,
  });
}
