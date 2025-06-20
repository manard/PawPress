class Veterinarian {
  final String username;
  final String email;
  final String phoneNumber;
  final String specialization;  // Required (already specified)
  final String? licenseNumber;  // Will be added later
  final String? contactDetails; // Will be added later
  final String? clinicName;     // Will be added later

  Veterinarian({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.specialization, // Marked as required
    this.licenseNumber,
    this.contactDetails, 
    this.clinicName,
  });

  factory Veterinarian.fromJson(Map<String, dynamic> json) {
    return Veterinarian(
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'], // No null check needed
      licenseNumber: json['licenseNumber'],
      contactDetails: json['contactDetails'],
      clinicName: json['clinicName'],
    );
  }
}