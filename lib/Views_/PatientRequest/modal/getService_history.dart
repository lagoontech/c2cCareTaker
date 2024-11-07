// To parse this JSON data, do
//
//     final serviceHistory = serviceHistoryFromJson(jsonString);

import 'dart:convert';

ServiceHistory serviceHistoryFromJson(String str) => ServiceHistory.fromJson(json.decode(str));

String serviceHistoryToJson(ServiceHistory data) => json.encode(data.toJson());

class ServiceHistory {
  bool? success;
  int? status;
  String? message;
  Data? data;

  ServiceHistory({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory ServiceHistory.fromJson(Map<String, dynamic> json) => ServiceHistory(
    success: json["success"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  int? appointmentId;
  int? patientId;
  int? caretakerId;
  String? patientBreakfasttime;
  String? patientBreakfasttimeDetails;
  String? patientLunchtime;
  String? patientLunchtimeDetails;
  String? patientSnackstime;
  String? patientSnackstimeDetails;
  String? patientDinnertime;
  String? patientDinnertimeDetails;
  String? patientMedications;
  String? patientMedicationsDetails;
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
  Caretaker? patient;
  Caretaker? caretaker;
  Appointment? appointment;

  Data({
    this.id,
    this.appointmentId,
    this.patientId,
    this.caretakerId,
    this.patientBreakfasttime,
    this.patientBreakfasttimeDetails,
    this.patientLunchtime,
    this.patientLunchtimeDetails,
    this.patientSnackstime,
    this.patientSnackstimeDetails,
    this.patientDinnertime,
    this.patientDinnertimeDetails,
    this.patientMedications,
    this.patientMedicationsDetails,
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
    this.patient,
    this.caretaker,
    this.appointment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    appointmentId: json["appointment_id"],
    patientId: json["patient_id"],
    caretakerId: json["caretaker_id"],
    patientBreakfasttime: json["patient_breakfasttime"],
    patientBreakfasttimeDetails: json["patient_breakfasttime_details"],
    patientLunchtime: json["patient_lunchtime"],
    patientLunchtimeDetails: json["patient_lunchtime_details"],
    patientSnackstime: json["patient_snackstime"],
    patientSnackstimeDetails: json["patient_snackstime_details"],
    patientDinnertime: json["patient_dinnertime"],
    patientDinnertimeDetails: json["patient_dinnertime_details"],
    patientMedications: json["patient_medications"],
    patientMedicationsDetails: json["patient_medications_details"],
    patientHydration: json["patient_hydration"],
    patientOralcare: json["patient_oralcare"],
    patientBathing: json["patient_bathing"],
    patientDressing: json["patient_dressing"],
    patientToileting: json["patient_toileting"],
    patientWalkingtime: json["patient_walkingtime"],
    patientVitalsigns: json["patient_vitalsigns"],
    patientBloodsugar: json["patient_bloodsugar"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    patient: json["patient"] == null ? null : Caretaker.fromJson(json["patient"]),
    caretaker: json["caretaker"] == null ? null : Caretaker.fromJson(json["caretaker"]),
    appointment: json["appointment"] == null ? null : Appointment.fromJson(json["appointment"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appointment_id": appointmentId,
    "patient_id": patientId,
    "caretaker_id": caretakerId,
    "patient_breakfasttime": patientBreakfasttime,
    "patient_breakfasttime_details": patientBreakfasttimeDetails,
    "patient_lunchtime": patientLunchtime,
    "patient_lunchtime_details": patientLunchtimeDetails,
    "patient_snackstime": patientSnackstime,
    "patient_snackstime_details": patientSnackstimeDetails,
    "patient_dinnertime": patientDinnertime,
    "patient_dinnertime_details": patientDinnertimeDetails,
    "patient_medications": patientMedications,
    "patient_medications_details": patientMedicationsDetails,
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
    "patient": patient?.toJson(),
    "caretaker": caretaker?.toJson(),
    "appointment": appointment?.toJson(),
  };
}

class Appointment {
  int? id;
  int? patientId;
  int? caretakerId;
  DateTime? appointmentDate;
  String? appointmentStartTime;
  String? appointmentEndTime;
  String? serviceStatus;
  String? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  Appointment({
    this.id,
    this.patientId,
    this.caretakerId,
    this.appointmentDate,
    this.appointmentStartTime,
    this.appointmentEndTime,
    this.serviceStatus,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    patientId: json["patient_id"],
    caretakerId: json["caretaker_id"],
    appointmentDate: json["appointment_date"] == null ? null : DateTime.parse(json["appointment_date"]),
    appointmentStartTime: json["appointment_start_time"],
    appointmentEndTime: json["appointment_end_time"],
    serviceStatus: json["service_status"],
    paymentStatus: json["payment_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "caretaker_id": caretakerId,
    "appointment_date": "${appointmentDate!.year.toString().padLeft(4, '0')}-${appointmentDate!.month.toString().padLeft(2, '0')}-${appointmentDate!.day.toString().padLeft(2, '0')}",
    "appointment_start_time": appointmentStartTime,
    "appointment_end_time": appointmentEndTime,
    "service_status": serviceStatus,
    "payment_status": paymentStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Caretaker {
  int? id;
  String? mobilenum;
  String? fcmToken;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  CaretakerInfo? caretakerInfo;
  PatientInfo? patientInfo;

  Caretaker({
    this.id,
    this.mobilenum,
    this.fcmToken,
    this.otp,
    this.otpverified,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.caretakerInfo,
    this.patientInfo,
  });

  factory Caretaker.fromJson(Map<String, dynamic> json) => Caretaker(
    id: json["id"],
    mobilenum: json["mobilenum"],
    fcmToken: json["fcm_token"],
    otp: json["otp"],
    otpverified: json["otpverified"],
    profileImageUrl: json["profile_image_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    caretakerInfo: json["caretaker_info"] == null ? null : CaretakerInfo.fromJson(json["caretaker_info"]),
    patientInfo: json["patient_info"] == null ? null : PatientInfo.fromJson(json["patient_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobilenum": mobilenum,
    "fcm_token": fcmToken,
    "otp": otp,
    "otpverified": otpverified,
    "profile_image_url": profileImageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "caretaker_info": caretakerInfo?.toJson(),
    "patient_info": patientInfo?.toJson(),
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "sex": sex,
    "age": age,
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
