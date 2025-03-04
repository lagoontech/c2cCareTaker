import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../api_urls/url.dart';
import '../../../../sharedPref/sharedPref.dart';
import '../../../Profile/modal/profile_model.dart';
import '../../../schedule/modal/medication_model.dart';

class CompletedAppointmentDetailsController extends GetxController{


  bool loadingServiceHistory = false;

  PatientSchedules? patientSchedules;
  DateTime ?selectedDate;
  ProfileList? profile;

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

  bool isLoading = false;

  //
  loadGetHistory({int? appointmentId, int? patientId}) async {

    loadingServiceHistory = true;
    update();
    try{
      String? token = await SharedPref().getToken();
      final uri = Uri.parse(URls().ServiceHistory).replace(queryParameters: {
        "appointment_id": appointmentId?.toString(),
        "patient_id": patientId?.toString(),
        "appointment_date": selectedDate.toString()
      });

      var res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        profile = ProfileList.fromJson(data);
        if (profile!.data != null && profile!.data!.patientSchedules != null) {
          patientSchedules = profile!.data!.patientSchedules!;
          pastSurgicalCT.text =
              patientSchedules!.patientPastsurgicalhistory ?? "";
          breakfastField.text = patientSchedules!.patientBreakfast!;
          lunchField.text = patientSchedules!.patientLunch ?? "";
          snacksField.text = patientSchedules!.patientSnacks ?? "";
          dinnerField.text = patientSchedules!.patientDinner ?? "";
          lunchDetail = patientSchedules!.patientLunch ?? "";
          snacksDetail = patientSchedules!.patientSnacks ?? "";
          dinnerDetail = patientSchedules!.patientDinner ?? "";
          breakFastDetail = patientSchedules!.patientBreakfast ?? "";
          print(breakFastDetail);
          activityCT.text = patientSchedules!.patientActivitytype ?? "";
          toileting.text = patientSchedules!.patientToileting ?? "";
          temp.text = patientSchedules!.patientVitalsigns!.temperature ?? "";
          bp.text = patientSchedules!.patientVitalsigns!.bloodPressure!;
          selectedWalkingTimings = jsonDecode(patientSchedules!.patientWalkingtime!);
          print(selectedWalkingTimings);
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

          print(patientSchedules!.patientMedications);
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
        print('Failed to load history: ${res.statusCode}');
        //fetchPrimaryInformationApi();
      }}catch(e){
      debugPrint('Error: $e');
    }
    loadingServiceHistory = false;
    update();
  }


}
