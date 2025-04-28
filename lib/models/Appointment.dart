class Appointment {
  final String id;
  final String petName;
  final DateTime appointmentDate;
  final String vetName;
  final String reason;

  Appointment({
    required this.id,
    required this.petName,
    required this.appointmentDate,
    required this.vetName,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petName': petName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'vetName': vetName,
      'reason': reason,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      petName: map['petName'],
      appointmentDate: DateTime.parse(map['appointmentDate']),
      vetName: map['vetName'],
      reason: map['reason'],
    );
  }
}
