// To parse this JSON data, do
//
//     final profileList = profileListFromJson(jsonString);

import 'dart:convert';

ProfileList profileListFromJson(String str) => ProfileList.fromJson(json.decode(str));

String profileListToJson(ProfileList data) => json.encode(data.toJson());

class ProfileList {
  bool? success;
  int? status;
  String? type;
  Data? data;
  String? profilePath;


  ProfileList({
    this.success,
    this.status,
    this.type,
    this.data,
    this.profilePath
  });

  factory ProfileList.fromJson(Map<String, dynamic> json) => ProfileList(
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
  DateTime? createdAt;
  String? profileImageUrl;
  DateTime? updatedAt;
  PatientInfo? patientInfo;
  PatientSchedules? patientSchedules;
  CaretakerInfo? caretakerInfo;
  List<PatientDocument>? patientDocuments;

  Data({
    this.id,
    this.mobilenum,
    this.otp,
    this.otpverified,
    this.createdAt,
    this.profileImageUrl,
    this.updatedAt,
    this.patientInfo,
    this.caretakerInfo,
    this.patientSchedules,
    this.patientDocuments
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    mobilenum: json["mobilenum"],
    otp: json["otp"],
    profileImageUrl: json["profile_image_url"],
    otpverified: json["otpverified"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    patientInfo: json["patient_info"] == null ? null : PatientInfo.fromJson(json["patient_info"]),
    caretakerInfo: json["caretaker_info"] == null ? null : CaretakerInfo.fromJson(json["caretaker_info"]),
    patientSchedules: json["patient_schedules"] == null ? null : PatientSchedules.fromJson(json["patient_schedules"]),
    patientDocuments: json["patient_documents"] == null
        ? []
        : List<PatientDocument>.from(json["patient_documents"]
        .map((x) => PatientDocument.fromJson(x))),

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
    "caretaker_info": caretakerInfo?.toJson(),
    "patient_schedules": patientSchedules?.toJson(),
    "patient_documents": patientDocuments == null
        ? []
        : List<dynamic>.from(patientDocuments!.map((x) => x.toJson())),
  };
}

class PatientDocument {
  int? id;
  int? patientId;
  String? fileName;
  String? documentName;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  bool?isDeletingDoc;

  PatientDocument({
    this.id,
    this.patientId,
    this.fileName,
    this.filePath,
    this.documentName,
    this.createdAt,
    this.updatedAt,
    this.isDeletingDoc = false,
  });

  factory PatientDocument.fromJson(Map<String, dynamic> json) =>
      PatientDocument(
        id: json["id"],
        patientId: json["patient_id"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        documentName: json["document_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "file_name": fileName,
    "document_name": documentName,
    "file_path": filePath,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class PatientInfo {
  int? id;
  int? patientId;
  String? firstName;
  String? lastName;
  String? sex;
  int? age;
  String?email;
  DateTime? dob;
  double? height;
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

  PatientInfo({
    this.id,
    this.patientId,
    this.firstName,
    this.lastName,
    this.sex,
    this.age,
    this.dob,
    this.email,
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

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
    id: json["id"],
    patientId: json["patient_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    sex: json["sex"],
    age: json["age"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    height: (json["height"] is int) ? (json["height"] as int).toDouble() : json["height"] as double?,
    weight: (json["weight"] is int) ? (json["weight"] as int).toDouble() : json["weight"] as double?,
    bmi: json["bmi"],
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "first_name": firstName,
    "last_name": lastName,
    "sex": sex,
    "age": age,
    "email":email,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
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


class CaretakerInfo {
  int? id;
  int? caretakerId;
  String? firstName;
  String? lastName;
  String? email;
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
  String? serviceCharge;
  String? totalPatientsAttended;
  DateTime? createdAt;
  DateTime? updatedAt;

  CaretakerInfo({
    this.id,
    this.caretakerId,
    this.firstName,
    this.lastName,
    this.email,
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
    this.serviceCharge,
    this.totalPatientsAttended,
    this.createdAt,
    this.updatedAt,
  });

  factory CaretakerInfo.fromJson(Map<String, dynamic> json) => CaretakerInfo(
    id: json["id"],
    caretakerId: json["caretaker_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
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
    serviceCharge: json["service_charge"],
    totalPatientsAttended: json["total_patients_attended"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "caretaker_id": caretakerId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
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
    "service_charge": serviceCharge,
    "total_patients_attended": totalPatientsAttended,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}



class PatientSchedules {
  int? id;
  int? patientId;
  List<String>? patientDietplan; // Change to List<String>
  String? patientActivitytype;
  List<String>? patientPastmedicalhistory; // Change to List<String>
  String? patientPastsurgicalhistory; // This is already a String
  String? patientBreakfasttime;
  String? patientSnackstime;
  String? patientLunchtime;
  String? patientDinnertime;
  String? patientMedications;
  String? patientHydration;
  String? patientOralcare;
  String? patientBathing;
  String? patientDressing;
  String? patientToileting;
  String? patientWalkingtime;
  PatientVitalSigns? patientVitalsigns;
  String? patientBloodsugar;
  DateTime? createdAt;
  DateTime? updatedAt;

  PatientSchedules({
    this.id,
    this.patientId,
    this.patientDietplan,
    this.patientActivitytype,
    this.patientPastmedicalhistory,
    this.patientPastsurgicalhistory,
    this.patientBreakfasttime,
    this.patientSnackstime,
    this.patientLunchtime,
    this.patientDinnertime,
    this.patientMedications,
    this.patientHydration,
    this.patientOralcare,
    this.patientBathing,
    this.patientDressing,
    this.patientToileting,
    this.patientWalkingtime,
    this.patientVitalsigns,
    this.patientBloodsugar,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientSchedules.fromJson(Map<String, dynamic> json) {
    return PatientSchedules(
      id: json["id"],
      patientId: json["patient_id"],
      patientDietplan: json["patient_dietplan"] != null
          ? List<String>.from(jsonDecode(json["patient_dietplan"]))
          : [],
      patientActivitytype: json["patient_activitytype"] ,
      patientPastmedicalhistory: json["patient_pastmedicalhistory"] != null
          ? List<String>.from(jsonDecode(json["patient_pastmedicalhistory"]))
          : [],
      patientPastsurgicalhistory: json["patient_pastsurgicalhistory"],
      patientBreakfasttime: json["patient_breakfasttime"],
      patientSnackstime: json['patient_snackstime'],
      patientLunchtime: json["patient_lunchtime"],
      patientDinnertime: json["patient_dinnertime"],
      patientMedications: json["patient_medications"],
      patientHydration: json["patient_hydration"],
      patientOralcare: json["patient_oralcare"],
      patientBathing: json["patient_bathing"],
      patientDressing: json["patient_dressing"],
      patientToileting: json["patient_toileting"],
      patientWalkingtime: json["patient_walkingtime"],
      patientVitalsigns: json['patient_vitalsigns'] != null
          ? PatientVitalSigns.fromJson(jsonDecode(json['patient_vitalsigns']))
          : null,
      patientBloodsugar: json["patient_bloodsugar"],
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "patient_dietplan": patientDietplan,
    "patient_activitytype": patientActivitytype,
    "patient_pastmedicalhistory": patientPastmedicalhistory,
    "patient_pastsurgicalhistory": patientPastsurgicalhistory,
    "patient_breakfasttime": patientBreakfasttime,
    "patient_snackstime": patientSnackstime,
    "patient_lunchtime": patientLunchtime,
    "patient_dinnertime": patientDinnertime,
    "patient_medications": patientMedications,
    "patient_hydration": patientHydration,
    "patient_oralcare": patientOralcare,
    "patient_bathing": patientBathing,
    "patient_dressing": patientDressing,
    "patient_toileting": patientToileting,
    "patient_walkingtime": patientWalkingtime,
    "patient_vitalsigns": patientVitalsigns,
    "patient_bloodsugar": patientBloodsugar,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
class PatientVitalSigns {
  String? bloodPressure;
  String? heartRate;
  String? respiratoryRate;
  String? temperature;
  String? weight;

  PatientVitalSigns({
    this.bloodPressure,
    this.heartRate,
    this.respiratoryRate,
    this.temperature,
    this.weight,
  });

  factory PatientVitalSigns.fromJson(Map<String, dynamic> json) {
    return PatientVitalSigns(
      bloodPressure: json['blood_pressure']?.toString(),
      heartRate: json['heart_rate']?.toString(),
      respiratoryRate: json['respiratory_rate']?.toString(),
      temperature: json['temperature']?.toString(),
      weight: json['weight']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'blood_pressure': bloodPressure,
    'heart_rate': heartRate,
    'respiratory_rate': respiratoryRate,
    'temperature': temperature,
    'weight': weight,
  };
}
