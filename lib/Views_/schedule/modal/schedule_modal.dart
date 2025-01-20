// import 'dart:convert';
//
// ScheduleModal scheduleModalFromJson(String str) =>
//     ScheduleModal.fromJson(json.decode(str));
//
// String scheduleModalToJson(ScheduleModal data) => json.encode(data.toJson());
//
// class ScheduleModal {
//   int patientId;
//   List<Diet> patientDietplan;
//   List<Activity> patientActivitytype;
//   List<MedicalHistory> patientPastmedicalhistory;
//   String patientPastsurgicalhistory;
//   String patientBreakfasttime;
//   String patientLunchtime;
//   String patientDinnertime;
//   String patientMedications;
//   String patientHydration;
//   String patientOralcare;
//   String patientBathing;
//   String patientDressing;
//   String patientToileting;
//   String patientWalkingtime;
//   PatientVitalsigns patientVitalsigns;
//   double patientBloodsugar;
//
//   ScheduleModal({
//     required this.patientId,
//     required this.patientDietplan,
//     required this.patientActivitytype,
//     required this.patientPastmedicalhistory,
//     required this.patientPastsurgicalhistory,
//     required this.patientBreakfasttime,
//     required this.patientLunchtime,
//     required this.patientDinnertime,
//     required this.patientMedications,
//     required this.patientHydration,
//     required this.patientOralcare,
//     required this.patientBathing,
//     required this.patientDressing,
//     required this.patientToileting,
//     required this.patientWalkingtime,
//     required this.patientVitalsigns,
//     required this.patientBloodsugar,
//   });
//
//   factory ScheduleModal.fromJson(Map<String, dynamic> json) => ScheduleModal(
//     patientId: json["patient_id"],
//     patientDietplan: List<Diet>.from(
//         json["patient_dietplan"].map((x) => Diet.fromJson(x))),
//     patientActivitytype: List<Activity>.from(
//         json["patient_activitytype"].map((x) => Activity.fromJson(x))),
//     patientPastmedicalhistory: List<MedicalHistory>.from(
//         json["patient_pastmedicalhistory"].map((x) => MedicalHistory.fromJson(x))),
//     patientPastsurgicalhistory: json["patient_pastsurgicalhistory"],
//     patientBreakfasttime: json["patient_breakfasttime"],
//     patientLunchtime: json["patient_lunchtime"],
//     patientDinnertime: json["patient_dinnertime"],
//     patientMedications: json["patient_medications"],
//     patientHydration: json["patient_hydration"],
//     patientOralcare: json["patient_oralcare"],
//     patientBathing: json["patient_bathing"],
//     patientDressing: json["patient_dressing"],
//     patientToileting: json["patient_toileting"],
//     patientWalkingtime: json["patient_walkingtime"],
//     patientVitalsigns: PatientVitalsigns.fromJson(json["patient_vitalsigns"]),
//     patientBloodsugar: json["patient_bloodsugar"]?.toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "patient_id": patientId,
//     "patient_dietplan": List<dynamic>.from(patientDietplan.map((x) => x.toJson())),
//     "patient_activitytype": List<dynamic>.from(patientActivitytype.map((x) => x.toJson())),
//     "patient_pastmedicalhistory": List<dynamic>.from(patientPastmedicalhistory.map((x) => x.toJson())),
//     "patient_pastsurgicalhistory": patientPastsurgicalhistory,
//     "patient_breakfasttime": patientBreakfasttime,
//     "patient_lunchtime": patientLunchtime,
//     "patient_dinnertime": patientDinnertime,
//     "patient_medications": patientMedications,
//     "patient_hydration": patientHydration,
//     "patient_oralcare": patientOralcare,
//     "patient_bathing": patientBathing,
//     "patient_dressing": patientDressing,
//     "patient_toileting": patientToileting,
//     "patient_walkingtime": patientWalkingtime,
//     "patient_vitalsigns": patientVitalsigns.toJson(),
//     "patient_bloodsugar": patientBloodsugar,
//   };
// }
//
// class PatientVitalsigns {
//   String bloodPressure;
//   int heartRate;
//   int respiratoryRate;
//   double temperature;
//   int weight;
//
//   PatientVitalsigns({
//     required this.bloodPressure,
//     required this.heartRate,
//     required this.respiratoryRate,
//     required this.temperature,
//     required this.weight,
//   });
//
//   factory PatientVitalsigns.fromJson(Map<String, dynamic> json) =>
//       PatientVitalsigns(
//         bloodPressure: json["blood_pressure"],
//         heartRate: json["heart_rate"],
//         respiratoryRate: json["respiratory_rate"],
//         temperature: json["temperature"]?.toDouble(),
//         weight: json["weight"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "blood_pressure": bloodPressure,
//     "heart_rate": heartRate,
//     "respiratory_rate": respiratoryRate,
//     "temperature": temperature,
//     "weight": weight,
//   };
// }
//
// /*
// class Diet {
//   final String name;
//   final int id;
//
//   Diet({required this.name, required this.id});
//
//   factory Diet.fromJson(Map<String, dynamic> json) => Diet(
//     name: json["name"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "id": id,
//   };
// }
//
// class Activity {
//   final String name;
//   final int id;
//
//   Activity({required this.name, required this.id});
//
//   factory Activity.fromJson(Map<String, dynamic> json) => Activity(
//     name: json["name"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "id": id,
//   };
// }
//
// class MedicalHistory {
//   final String name;
//   final int id;
//
//   MedicalHistory({required this.name, required this.id});
//
//   factory MedicalHistory.fromJson(Map<String, dynamic> json) => MedicalHistory(
//     name: json["name"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "id": id,
//   };
// }
// */
