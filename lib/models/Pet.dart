class Pet {
  final int petID;
  final int userID;
  final String name;
  final int age;
  final String breed;
  final String gender;
  final String image;
  final String? health_record_path; // New field added

  Pet({
    required this.petID,
    required this.userID,
    required this.name,
    required this.age,
    required this.breed,
    required this.gender,
    required this.image,
    this.health_record_path, // New field added
  });

  // Factory method to create Pet from JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petID: int.parse(json['petID'].toString()),
      userID: int.parse(json['userID'].toString()),
      name: json['name'],
      age: int.parse(json['age'].toString()),
      breed: json['breed'],
      gender: json['gender'],
      image: json['image'],
      health_record_path: json['health_record_path'], // New field added
    );
  }

  // Convert Pet object to JSON
  Map<String, dynamic> toJson() {
    return {
      'petID': petID,
      'userID': userID,
      'name': name,
      'age': age,
      'breed': breed,
      'gender': gender,
      'image': image,
      'health_record_path': health_record_path, // New field added
    };
  }
}
