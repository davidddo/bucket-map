import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Profile {
  const Profile({
    String id,
    this.email,
    this.firstName,
    this.lastName,
    this.country,
    this.unlockedCountries,
  }) : this.id = id;

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String country;
  final List<String> unlockedCountries;

  Profile copyWith({
    String id,
    String email,
    String firstName,
    String lastName,
    String country,
    List<String> unlockedCountries,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      unlockedCountries: unlockedCountries ?? this.unlockedCountries,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      country.hashCode ^
      unlockedCountries.hashCode;

  @override
  String toString() {
    return 'Profile { id: $id, email: $email, firstName: $firstName, lastName: $lastName, country: $country, unlockedCountries: $unlockedCountries}';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "country": country,
      "unlockedCountries": unlockedCountries
    };
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "country": country,
      "unlockedCountries": unlockedCountries,
    };
  }

  static Profile fromJson(Map<String, Object> json) {
    return Profile(
      id: json["id"] as String,
      email: json["email"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      country: json["country"] as String,
      unlockedCountries: json["unlockedCountries"] as List<String>,
    );
  }

  static Profile fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();

    return Profile(
      id: data['id'],
      email: data['email'],
      firstName: data["firstName"] as String,
      lastName: data["lastName"] as String,
      country: data["country"] as String,
      unlockedCountries: data['unlockedCountries'].cast<String>(),
    );
  }
}
