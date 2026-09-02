import 'package:flutter/foundation.dart';

enum ProfessionalSpecialty { haircut, beard, haircutAndBeard, eyebrow }

class Professional {
  final String id;
  final String name;
  final String specialty;
  final ProfessionalSpecialty specialtyType;
  final List<String> availableHours;
  final String image;
  final int rating;
  final String bio;

  const Professional({
    required this.id,
    required this.name,
    required this.specialty,
    required this.specialtyType,
    required this.availableHours,
    required this.image,
    required this.rating,
    required this.bio,
  });

  Professional copyWith({
    String? id,
    String? name,
    String? specialty,
    ProfessionalSpecialty? specialtyType,
    List<String>? availableHours,
    String? image,
    int? rating,
    String? bio,
  }) {
    return Professional(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      specialtyType: specialtyType ?? this.specialtyType,
      availableHours: availableHours ?? this.availableHours,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      bio: bio ?? this.bio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) && other is Professional && other.id == id;

  @override
  int get hashCode => id.hashCode;
}