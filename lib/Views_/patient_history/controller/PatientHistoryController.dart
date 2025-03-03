import 'dart:convert';

import 'package:care2caretaker/api_urls/url.dart';
import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Profile/modal/profile_model.dart';
import '../../../reuse_widgets/customToast.dart';
import '../../schedule/modal/medication_model.dart';

class PatientHistoryController extends GetxController {

  var selectedPatient = '';
  var selectedHydration = '';
  var selectOral = '';
  var selectBath = '';
  var selectDressing = '';
  var selectMedication = '';

  TimeOfDay? breakfastTime;
  TimeOfDay? lunchTime;
  TimeOfDay? snacksTime;
  TimeOfDay? dinnerTime;

  TextEditingController breakfastField = TextEditingController();
  TextEditingController lunchField = TextEditingController();
  TextEditingController snacksField = TextEditingController();
  TextEditingController dinnerField = TextEditingController();

  final List<String> patients = ['Yes', 'No'];
  final List<String> oralList = ['Yes', 'No'];
  final List<String> Bathing = ['Yes', 'No'];
  final List<String> Medication = ['Yes', 'No'];
  final List<String> dressingList = ['Yes', 'No'];
  final List<String> hydration = ['500ML', '1L', '2L', '3L', '4L'];

  TextEditingController toiletingCT = TextEditingController();
  TextEditingController TempCT = TextEditingController();
  TextEditingController PulseCT = TextEditingController();
  TextEditingController Respirations = TextEditingController();
  TextEditingController BloodSugar = TextEditingController();
  TextEditingController medicationCT = TextEditingController();
  TextEditingController BloodPressure = TextEditingController();

  final List<String> filters = [];
  final List<String> lunchFilters = [];
  final List<String> snacks = [];
  final List<String> dinner = [];
  List<String> meditations = [];
  List<MedicationModel> meditationDetails = [];
  String ?selectedMedication;
  final List<String> blood = [];

  String breakFastDetail = "";
  String lunchDetail     = "";
  String snacksDetail    = "";
  String dinnerDetail    = "";

  final List<String> breakFast = [
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
  ];
  final List<String> lunchList = [
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
  ];
  final List<String> dinnerList = [
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
  ];
  final List<String> snackList = [
    '10:00 AM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  final List<String> Hydration = [
    '500ML',
    '1L',
    '2L',
    '3L',
    '4L',
    '5L',
    '6L',
    '7L',
    '8L',
    '9L'
  ];
  var selectedOption = '';
  var oralSelection = '';
  var ostomySelection = '';
  var bathingSelection = '';
  var dressingSelection = '';
  var walkingTime = '';
  var medidation = '';
  List<dynamic> selectedOralCareTimings = [];
  List<dynamic> selectedBathingTimings  = [];
  List<dynamic> selectedDressingTimings = [];
  List<dynamic> selectedWalkingTimings = [];
  TextEditingController medicalHistoryCT = TextEditingController();
  TextEditingController toileting = TextEditingController();
  TextEditingController bp = TextEditingController();
  TextEditingController bloodSugarTEC = TextEditingController();
  TextEditingController heartRate = TextEditingController();
  TextEditingController hydrationTEC = TextEditingController();
  TextEditingController respiration = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController activityCT = TextEditingController();
  TextEditingController pastSurgicalCT = TextEditingController();

  DateTime ?selectedDate;

  bool isLoading = false;

  //
  getSessionDetails() async{

    try{

    }catch(e){
      print("Error getting session details-->$e");
    }

  }

  //
  setInitialMedication(){

    medidation = "Morning";
    selectedMedication = "Morning";
    meditationDetails = [
      MedicationModel(time: "Morning",medicationDetails: []),
      MedicationModel(time: "Noon",medicationDetails: []),
      MedicationModel(time: "Evening",medicationDetails: []),
    ];
  }

  //
  String _timeToString(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // Return formatted string
    return '${formattedTime.hour}:${formattedTime.minute.toString().padLeft(2, '0')}';
  }

  ProfileList? profile;
  PatientSchedules? patientSchedules;
  int? patientID;
  //
  //
  Future<void> fetchPrimaryInformationApi() async {
    try {
      String? token = await SharedPref().getToken();
      String? patientIDStr = await SharedPref().getId();
      print(patientID);
      var response = await http.get(
        Uri.parse(URls().individualPatient+"?patient_id=$patientID"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        profile = ProfileList.fromJson(jsonResponse);
        update();
        if (profile!.data != null && profile!.data!.patientSchedules != null) {
          patientSchedules = profile!.data!.patientSchedules!;
          pastSurgicalCT.text =
              patientSchedules!.patientPastsurgicalhistory!.toString();
          activityCT.text = patientSchedules!.patientActivitytype!;
          toileting.text = patientSchedules!.patientToileting!;
          temp.text = 120.toString();
          bp.text = patientSchedules!.patientVitalsigns!.bloodPressure!;
          selectedWalkingTimings = jsonDecode(patientSchedules!.patientWalkingtime!);
          heartRate.text =
              patientSchedules!.patientVitalsigns!.heartRate.toString();
          respiration.text =
          patientSchedules!.patientVitalsigns!.respiratoryRate!;

          ///
          if (patientSchedules!.patientBreakfasttime != null &&
              patientSchedules!.patientBreakfasttime!.isNotEmpty) {
            filters.clear();
            filters.add(patientSchedules!.patientBreakfasttime!);
            update();
          }

          if (patientSchedules!.patientMedications != null &&
              patientSchedules!.patientMedications!.isNotEmpty) {
            medidation = "Morning";
            meditationDetails = [
              MedicationModel(time: "Morning",medicationDetails: []),
              MedicationModel(time: "Noon",medicationDetails: []),
              MedicationModel(time: "Evening",medicationDetails: []),
            ];
            var medicationValues = jsonDecode(patientSchedules!.patientMedications!);
            medicationValues.keys.forEach((time) {
              List<dynamic> ?details = medicationValues[time];
              if(time == "Morning"){
                details!.forEach((element) {
                  meditationDetails[0].medicationDetails!.add(TextEditingController(text:element.toString()));
                });
              }
              if(time == "Noon"){
                details!.forEach((element) {
                  meditationDetails[1].medicationDetails!.add(TextEditingController(text:element.toString()));
                });
              }
              if(time == "Evening"){
                details!.forEach((element) {
                  meditationDetails[2].medicationDetails!.add(TextEditingController(text:element.toString()));
                });
              }
            });
            selectedMedication = medidation;
            debugPrint(medidation);
            update();
          }
          if (patientSchedules!.patientOralcare != null &&
              patientSchedules!.patientOralcare!.isNotEmpty) {
            //oralSelection = patientSchedules!.patientOralcare!;
            selectedOralCareTimings = jsonDecode(patientSchedules!.patientOralcare!);
            debugPrint(medidation);
            update();
          }
          if (patientSchedules!.patientBathing != null &&
              patientSchedules!.patientBathing!.isNotEmpty) {
            //bathingSelection = patientSchedules!.patientBathing!;
            selectedBathingTimings = jsonDecode(patientSchedules!.patientBathing!);

            debugPrint(medidation);
            update();
          }
          if (patientSchedules!.patientDressing != null &&
              patientSchedules!.patientDressing!.isNotEmpty) {
            //dressingSelection = patientSchedules!.patientDressing!;
            selectedDressingTimings = jsonDecode(patientSchedules!.patientDressing!);
            debugPrint(medidation);
            update();
          }

          if (patientSchedules!.patientLunchtime != null &&
              patientSchedules!.patientLunchtime!.isNotEmpty) {
            lunchFilters.clear();
            lunchFilters.add(patientSchedules!.patientLunchtime!);
            update();
          }
          if (patientSchedules!.patientHydration != null &&
              patientSchedules!.patientHydration!.isNotEmpty) {
            hydrationTEC.text = patientSchedules!.patientHydration!;
            update();
          }

          if (patientSchedules!.patientSnackstime != null &&
              patientSchedules!.patientSnackstime!.isNotEmpty) {
            snacks.clear();
            snacks.add(patientSchedules!.patientSnackstime!);
            update();
          }

          if (patientSchedules!.patientDinnertime != null &&
              patientSchedules!.patientDinnertime!.isNotEmpty) {
            dinner.clear();
            dinner.add(patientSchedules!.patientDinnertime!);
            update();
          }
          if (patientSchedules!.patientBloodsugar != null &&
              patientSchedules!.patientBloodsugar!.isNotEmpty) {
            bloodSugarTEC.text = patientSchedules!.patientBloodsugar!;
            update();
          }
          update();
        } else {
          debugPrint("No patient schedules found.");
        }
      } else {
        debugPrint("Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  //
  Future<void> postPatientHistory({int? appointmentId, int? patientId}) async {

    isLoading = true;
    update();
    final Map<String, dynamic> data = {
      "appointment_id": appointmentId,
      "patient_id": patientId,
      "patient_breakfasttime": patientSchedules!.patientBreakfasttime,
      "patient_breakfasttime_details": breakFastDetail,
      "patient_lunchtime": patientSchedules!.patientLunchtime,
      "patient_lunchtime_details": lunchDetail,
      "patient_snackstime": patientSchedules!.patientSnackstime,
      "patient_snackstime_details": snacksDetail,
      "patient_dinnertime": patientSchedules!.patientDinnertime,
      "patient_dinnertime_details": dinnerDetail,
      "patient_medications_details": {
        "Morning": meditationDetails.firstWhere((element) => element.time=="Morning").medicationDetails!.map((e) => e.text).toList(),
        "Noon": meditationDetails.firstWhere((element) => element.time=="Noon").medicationDetails!.map((e) => e.text).toList(),
        "Evening": meditationDetails.firstWhere((element) => element.time=="Evening").medicationDetails!.map((e) => e.text).toList()
      },
      "patient_hydration": hydrationTEC.text,
      "patient_oralcare": selectedOralCareTimings,
      "patient_bathing": selectedBathingTimings,
      "patient_dressing": selectedDressingTimings,
      "patient_toileting": toileting.text,
      "patient_walkingtime": selectedWalkingTimings,
      "patient_vitalsigns": {
        "blood_pressure": bp.text,
        "heart_rate": heartRate.text,
        "respiratory_rate": respiration.text,
        "temperature": temp.text,
      },
      "patient_bloodsugar": bloodSugarTEC.text,
      "appointment_date": selectedDate.toString()
    };

    try {
      String? token = await SharedPref().getToken();
      final response = await http.post(
        Uri.parse(URls().serviceHistory),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Data submitted successfully: ${response.body}");
        showCustomToast(message: "Service Status Updated Successfully");
        Get.back(result: 1);
      } else {
        print("Failed to submit data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoading = false;
    update();

  }
}
