class Pet {
  final int petID;
  final int ownerID;
  final String name;
  final int age;
  final String breed;
  final String gender;
  final String image;

  Pet({
    required this.petID,
    required this.ownerID,
    required this.name,
    required this.age,
    required this.breed,
    required this.gender,
    required this.image,
  });

  // Factory method to create Pet from JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petID: int.parse(json['petID'].toString()),
      ownerID: int.parse(json['ownerID'].toString()),
      name: json['name'],
      age: int.parse(json['age'].toString()),
      breed: json['breed'],
      gender: json['gender'],
      image: json['image'],
    );
  }

  // Convert Pet object to JSON
  Map<String, dynamic> toJson() {
    return {
      'petID': petID,
      'ownerID': ownerID,
      'name': name,
      'age': age,
      'breed': breed,
      'gender': gender,
      'image': image,
    };
  }
}
