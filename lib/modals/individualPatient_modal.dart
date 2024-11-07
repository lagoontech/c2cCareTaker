import 'dart:convert';

PatientInfo patientInfoFromJson(String str) =>
    PatientInfo.fromJson(json.decode(str));

String patientInfoToJson(PatientInfo data) => json.encode(data.toJson());

class PatientInfo {
  bool? success;
  int? status;
  String? type;
  Data? data;
  String? profilePath;

  PatientInfo({
    this.success,
    this.status,
    this.type,
    this.data,
    this.profilePath,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
        success: json["success"],
        status: json["status"],
        type: json["type"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "type": type,
        "data": data?.toJson(),
        "profile_path": profilePath,
      };
}

class Data {
  int? id;
  String? mobilenum;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  PatientInfoClass? patientInfo;
  List<dynamic>? patientDocuments;

  Data({
    this.id,
    this.mobilenum,
    this.otp,
    this.otpverified,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.patientInfo,
    this.patientDocuments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        mobilenum: json["mobilenum"],
        otp: json["otp"],
        otpverified: json["otpverified"],
        profileImageUrl: json["profile_image_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        patientInfo: json["patient_info"] == null
            ? null
            : PatientInfoClass.fromJson(json["patient_info"]),
        patientDocuments: json["patient_documents"] == null
            ? []
            : List<dynamic>.from(json["patient_documents"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobilenum": mobilenum,
        "otp": otp,
        "otpverified": otpverified,
        "profile_image_url": profileImageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient_info": patientInfo?.toJson(),
        "patient_documents": patientDocuments == null
            ? []
            : List<dynamic>.from(patientDocuments!.map((x) => x)),
      };
}

class PatientInfoClass {
  int? id;
  int? patientId;
  String? firstName;
  String? lastName;
  String? email;
  String? sex;
  int? age;
  DateTime? dob;
  int? height;
  double? weight;
  double? bmi;
  String? location;
  String? nationality;
  String? address;
  String? diagnosis;
  dynamic primaryCareGiverName;
  String? primaryContactName;
  String? primaryContactNumber;
  String? secondaryContactName;
  String? secondaryContactNumber;
  String? specialistName;
  String? specialistContactNumber;
  dynamic moreinfo;
  DateTime? createdAt;
  DateTime? updatedAt;

  PatientInfoClass({
    this.id,
    this.patientId,
    this.firstName,
    this.lastName,
    this.email,
    this.sex,
    this.age,
    this.dob,
    this.height,
    this.weight,
    this.bmi,
    this.location,
    this.nationality,
    this.address,
    this.diagnosis,
    this.primaryCareGiverName,
    this.primaryContactName,
    this.primaryContactNumber,
    this.secondaryContactName,
    this.secondaryContactNumber,
    this.specialistName,
    this.specialistContactNumber,
    this.moreinfo,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientInfoClass.fromJson(Map<String, dynamic> json) =>
      PatientInfoClass(
        id: json["id"],
        patientId: json["patient_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        sex: json["sex"],
        age: json["age"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        height: json["height"],
        weight: json["weight"]?.toDouble(),
        bmi: json["bmi"]?.toDouble(),
        location: json["location"],
        nationality: json["nationality"],
        address: json["address"],
        diagnosis: json["diagnosis"],
        primaryCareGiverName: json["primary_care_giver_name"],
        primaryContactName: json["primary_contact_name"],
        primaryContactNumber: json["primary_contact_number"],
        secondaryContactName: json["secondary_contact_name"],
        secondaryContactNumber: json["secondary_contact_number"],
        specialistName: json["specialist_name"],
        specialistContactNumber: json["specialist_contact_number"],
        moreinfo: json["moreinfo"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "sex": sex,
        "age": age,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "height": height,
        "weight": weight,
        "bmi": bmi,
        "location": location,
        "nationality": nationality,
        "address": address,
        "diagnosis": diagnosis,
        "primary_care_giver_name": primaryCareGiverName,
        "primary_contact_name": primaryContactName,
        "primary_contact_number": primaryContactNumber,
        "secondary_contact_name": secondaryContactName,
        "secondary_contact_number": secondaryContactNumber,
        "specialist_name": specialistName,
        "specialist_contact_number": specialistContactNumber,
        "moreinfo": moreinfo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
