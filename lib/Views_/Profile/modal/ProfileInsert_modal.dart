// To parse this JSON data, do
//
//     final profileInsert = profileInsertFromJson(jsonString);

import 'dart:convert';

ProfileInsert profileInsertFromJson(String str) => ProfileInsert.fromJson(json.decode(str));

String profileInsertToJson(ProfileInsert data) => json.encode(data.toJson());

class ProfileInsert {
  bool? success;
  int? status;
  String? type;
  Data? data;

  ProfileInsert({
    this.success,
    this.status,
    this.type,
    this.data,
  });

  factory ProfileInsert.fromJson(Map<String, dynamic> json) => ProfileInsert(
    success: json["success"],
    status: json["status"],
    type: json["type"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "type": type,
    "data": data?.toJson(),
  };
}

class Data {
  int? caretakerId;
  String? firstName;
  String? lastName;
  String? sex;
  int? age;
  DateTime? dob;
  String? medicalLicense;
  String? location;
  String? nationality;
  String? address;
  String? uploadedDocuments;
  String? yearOfExperiences;
  String? primaryContactNumber;
  String? secondaryContactNumber;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.caretakerId,
    this.firstName,
    this.lastName,
    this.sex,
    this.age,
    this.dob,
    this.medicalLicense,
    this.location,
    this.nationality,
    this.address,
    this.uploadedDocuments,
    this.yearOfExperiences,
    this.primaryContactNumber,
    this.secondaryContactNumber,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    caretakerId: json["caretaker_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    sex: json["sex"],
    age: json["age"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    medicalLicense: json["medical_license"],
    location: json["location"],
    nationality: json["nationality"],
    address: json["address"],
    uploadedDocuments: json["uploaded_documents"],
    yearOfExperiences: json["year_of_experiences"],
    primaryContactNumber: json["primary_contact_number"],
    secondaryContactNumber: json["secondary_contact_number"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "caretaker_id": caretakerId,
    "first_name": firstName,
    "last_name": lastName,
    "sex": sex,
    "age": age,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "medical_license": medicalLicense,
    "location": location,
    "nationality": nationality,
    "address": address,
    "uploaded_documents": uploadedDocuments,
    "year_of_experiences": yearOfExperiences,
    "primary_contact_number": primaryContactNumber,
    "secondary_contact_number": secondaryContactNumber,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
