// To parse this JSON data, do
//
//     final careTakersList = careTakersListFromJson(jsonString);

import 'dart:convert';

CareTakersList careTakersListFromJson(String str) =>
    CareTakersList.fromJson(json.decode(str));

String careTakersListToJson(CareTakersList data) => json.encode(data.toJson());

class CareTakersList {
  bool? success;
  int? status;
  String? type;
  List<Datum>? data;
  String? profilePath;

  CareTakersList({
    this.success,
    this.status,
    this.type,
    this.data,
    this.profilePath,
  });

  factory CareTakersList.fromJson(Map<String, dynamic> json) => CareTakersList(
        success: json["success"],
        status: json["status"],
        type: json["type"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "type": type,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "profile_path": profilePath,
      };
}

class Datum {
  int? id;
  int? appointmentId;
  int? patientId;
  int? caretakerId;
  DateTime? appointmentDate;
  String? appointmentStartTime;
  String? appointmentEndTime;
  String? serviceStatus;
  String? cancelReason;
  String? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  Patient? patient;

  Datum({
    this.id,
    this.appointmentId,
    this.patientId,
    this.caretakerId,
    this.appointmentDate,
    this.appointmentStartTime,
    this.appointmentEndTime,
    this.serviceStatus,
    this.cancelReason,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.patient,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        appointmentId: json['appointment_id'],
        patientId: json["patient_id"],
        caretakerId: json["caretaker_id"],
        appointmentDate: json["appointment_date"] == null
            ? null
            : DateTime.parse(json["appointment_date"]),
        appointmentStartTime: json["appointment_start_time"],
        appointmentEndTime: json["appointment_end_time"],
        serviceStatus: json["service_status"],
        cancelReason: json['cancel_reason'],
        paymentStatus: json["payment_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'appointment_id': appointmentId,
        "patient_id": patientId,
        "caretaker_id": caretakerId,
        "appointment_date":
            "${appointmentDate!.year.toString().padLeft(4, '0')}-${appointmentDate!.month.toString().padLeft(2, '0')}-${appointmentDate!.day.toString().padLeft(2, '0')}",
        "appointment_start_time": appointmentStartTime,
        "appointment_end_time": appointmentEndTime,
        "service_status": serviceStatus,
        "cancel_reason": cancelReason,
        "payment_status": paymentStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient": patient?.toJson(),
      };
}

class Patient {
  int? id;
  String? mobilenum;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  PatientInfo? patientInfo;
  PatientSchedules? patientSchedules;

  Patient({
    this.id,
    this.mobilenum,
    this.otp,
    this.otpverified,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.patientInfo,
    this.patientSchedules,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
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
        patientSchedules: json["patient_schedules"] == null
            ? null
            : PatientSchedules.fromJson(json["patient_schedules"]),
        patientInfo: json["patient_info"] == null
            ? null
            : PatientInfo.fromJson(json["patient_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobilenum": mobilenum,
        "otp": otp,
        "otpverified": otpverified,
        "profile_image_url": profileImageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient_schedules": patientSchedules?.toJson(),
        "patient_info": patientInfo?.toJson(),
      };
}

class PatientInfo {
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
  String? moreinfo;
  DateTime? createdAt;
  DateTime? updatedAt;

  PatientInfo({
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

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
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

class PatientSchedules {
  int? id;
  int? patientId;
  String? patientDietplan;
  String? patientActivitytype;
  String? patientPastmedicalhistory;
  String? patientPastsurgicalhistory;
  String? patientBreakfasttime;
  String? patientLunchtime;
  String? patientSnackstime;
  String? patientDinnertime;
  String? patientMedications;
  String? patientHydration;
  String? patientOralcare;
  String? patientBathing;
  String? patientDressing;
  String? patientToileting;
  String? patientWalkingtime;
  String? patientVitalsigns;
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
    this.patientLunchtime,
    this.patientSnackstime,
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

  factory PatientSchedules.fromJson(Map<String, dynamic> json) =>
      PatientSchedules(
        id: json["id"],
        patientId: json["patient_id"],
        patientDietplan: json["patient_dietplan"],
        patientActivitytype: json["patient_activitytype"],
        patientPastmedicalhistory: json["patient_pastmedicalhistory"],
        patientPastsurgicalhistory: json["patient_pastsurgicalhistory"],
        patientBreakfasttime: json["patient_breakfasttime"],
        patientLunchtime: json["patient_lunchtime"],
        patientSnackstime: json["patient_snackstime"],
        patientDinnertime: json["patient_dinnertime"],
        patientMedications: json["patient_medications"],
        patientHydration: json["patient_hydration"],
        patientOralcare: json["patient_oralcare"],
        patientBathing: json["patient_bathing"],
        patientDressing: json["patient_dressing"],
        patientToileting: json["patient_toileting"],
        patientWalkingtime: json["patient_walkingtime"],
        patientVitalsigns: json["patient_vitalsigns"],
        patientBloodsugar: json["patient_bloodsugar"],
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
        "patient_dietplan": patientDietplan,
        "patient_activitytype": patientActivitytype,
        "patient_pastmedicalhistory": patientPastmedicalhistory,
        "patient_pastsurgicalhistory": patientPastsurgicalhistory,
        "patient_breakfasttime": patientBreakfasttime,
        "patient_lunchtime": patientLunchtime,
        "patient_snackstime": patientSnackstime,
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
