// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Studentmodel {
  final String student_name;
  final String date_of_birth;
  final String gender;
  final int owner_id;
  final int id;
  final String student_age;
  final String country;
  final String image;
  Studentmodel({
    required this.student_name,
    required this.date_of_birth,
    required this.gender,
    required this.owner_id,
    required this.id,
    required this.student_age,
    required this.country,
    required this.image,
  });

  Studentmodel copyWith({
    String? student_name,
    String? date_of_birth,
    String? gender,
    int? owner_id,
    int? id,
    String? student_age,
    String? country,
    String? image,
  }) {
    return Studentmodel(
      student_name: student_name ?? this.student_name,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      gender: gender ?? this.gender,
      owner_id: owner_id ?? this.owner_id,
      id: id ?? this.id,
      student_age: student_age ?? this.student_age,
      country: country ?? this.country,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student_name': student_name,
      'date_of_birth': date_of_birth,
      'gender': gender,
      'owner_id': owner_id,
      'id': id,
      'student_age': student_age,
      'country': country,
      'image': image,
    };
  }

  factory Studentmodel.fromMap(Map<String, dynamic> map) {
    return Studentmodel(
      student_name: map['student_name'] as String,
      date_of_birth: map['date_of_birth'] as String,
      gender: map['gender'] as String,
      owner_id: map['owner_id'].toInt() as int,
      id: map['id'].toInt() as int,
      student_age: map['student_age'] as String,
      country: map['country'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Studentmodel.fromJson(String source) =>
      Studentmodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Studentmodel(student_name: $student_name, date_of_birth: $date_of_birth, gender: $gender, owner_id: $owner_id, id: $id, student_age: $student_age, country: $country, image: $image)';
  }

  @override
  bool operator ==(covariant Studentmodel other) {
    if (identical(this, other)) return true;

    return other.student_name == student_name &&
        other.date_of_birth == date_of_birth &&
        other.gender == gender &&
        other.owner_id == owner_id &&
        other.id == id &&
        other.student_age == student_age &&
        other.country == country &&
        other.image == image;
  }

  @override
  int get hashCode {
    return student_name.hashCode ^
        date_of_birth.hashCode ^
        gender.hashCode ^
        owner_id.hashCode ^
        id.hashCode ^
        student_age.hashCode ^
        country.hashCode ^
        image.hashCode;
  }
}
