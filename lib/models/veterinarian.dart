class Veterinarian {
  final String username;
  final String licenseNumber;
  final String contactDetails;
  final String specialization;
  final String clinicName;
  final String email; // ✅ new
  final String phoneNumber; // ✅ new

  Veterinarian({
    required this.username,
    required this.licenseNumber,
    required this.contactDetails,
    required this.specialization,
    required this.clinicName,
    required this.email, // ✅ new
    required this.phoneNumber, // ✅ new
  });
}
