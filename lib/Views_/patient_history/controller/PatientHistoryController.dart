import 'dart:convert';
import 'dart:developer';
import 'package:care2caretaker/Views_/patient_history/Models/service_status_model.dart';
import 'package:care2caretaker/api_urls/url.dart';
import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../PatientRequest/modal/getService_history.dart';
import '../../Profile/modal/profile_model.dart';
import '../../../Utils/http_service.dart';
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

  bool loadingServiceHistory = false;

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

  @override
  void onInit(){
    super.onInit();
    //getServiceStatus();
  }

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
  int ?appointmentId;
  bool completeService = false;
  List<ServiceStatusModel> statuses = [];
  bool isServiceComplete = false;

  //
  getServiceStatus({int ?appointmentId,int ?patientId}) async{

    patientID = patientId;
    this.appointmentId = appointmentId;

    try{
      var result = await HttpService.instance.get(
          Uri.parse(URls().ServiceStatus+"?appointment_id=$appointmentId&patient_id=$patientId"),
          headers: {
            "Authorization": "Bearer ${await SharedPref().getToken()}",
          }
      );
      if(result.statusCode == 200){
        var jsonResponse = jsonDecode(result.body);
        statuses = (jsonResponse["data"]["service_status_list"] as List).map((e){
          return ServiceStatusModel.fromJson(e);
        }).toList();
      }
      checkStatus();
      completeServiceStatus();
    }catch(e){
      print(e);
    }

  }

  //
  completeServiceStatus() async{

    for(int i=0;i<statuses.length;i++){
      if(statuses[i].status == 0){
        return;
      }
    }
    try{
      var result = await HttpService.instance.post(Uri.parse(URls().completeService),
      headers: {
        "Authorization": "Bearer ${await SharedPref().getToken()}",
        "Content-Type": "application/json",
      },body: jsonEncode({
        "patient_id": patientID,
        "appointment_id": appointmentId,
          }));
      if(result.statusCode == 200){
        print("Service completed");
      }
    }catch(e){
      print("Error completing service");
    }

  }

  //
  checkStatus(){

    if(selectedDate!=null){
      statuses.forEach((element) {
        final parsedDate = DateTime.tryParse(element.serviceDate ?? '');
        if(parsedDate != null && DateFormat("MMM dd").format(parsedDate) == DateFormat("MMM dd").format(selectedDate!)){
          isServiceComplete = element.status == 1 ? true : false;
        }
      });
    }
    print("Service complete-->$isServiceComplete");
    update();

  }

  List<dynamic> _parseDynamicList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return decoded;
      } catch (e) {
        return [value];
      }
    }
    return [];
  }

  void clearAllFields() {
    breakfastField.clear();
    lunchField.clear();
    snacksField.clear();
    dinnerField.clear();
    breakFastDetail = "";
    lunchDetail = "";
    snacksDetail = "";
    dinnerDetail = "";
    
    toileting.clear();
    temp.clear();
    bp.clear();
    heartRate.clear();
    respiration.clear();
    bloodSugarTEC.clear();
    hydrationTEC.clear();
    pastSurgicalCT.clear();
    activityCT.clear();
    
    selectedOralCareTimings = [];
    selectedBathingTimings = [];
    selectedDressingTimings = [];
    selectedWalkingTimings = [];
    
    filters.clear();
    lunchFilters.clear();
    snacks.clear();
    dinner.clear();
    
    setInitialMedication();
  }

  //
  Future<void> fetchPrimaryInformationApi() async {
    clearAllFields();
    try {
      String? token = await SharedPref().getToken();
      String? patientIDStr = await SharedPref().getId();
      print(patientID);
      var response = await HttpService.instance.get(
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
        final schedules = profile?.data?.patientSchedules;
        if (schedules != null) {
          patientSchedules = schedules;
          pastSurgicalCT.text =
              schedules.patientPastsurgicalhistory?.toString() ?? "";
          activityCT.text = schedules.patientActivitytype ?? "";
          toileting.text = schedules.patientToileting ?? "";
          temp.text = schedules.patientVitalsigns?.temperature ?? "";
          bp.text = schedules.patientVitalsigns?.bloodPressure ?? "";
          selectedWalkingTimings = _parseDynamicList(schedules.patientWalkingtime);
          heartRate.text =
              schedules.patientVitalsigns?.heartRate?.toString() ?? "";
          respiration.text =
              schedules.patientVitalsigns?.respiratoryRate ?? "";

          ///
          if (schedules.patientBreakfasttime != null &&
              schedules.patientBreakfasttime!.isNotEmpty) {
            filters.clear();
            filters.add(schedules.patientBreakfasttime!);
            update();
          }

          if (schedules.patientMedications != null &&
              schedules.patientMedications!.isNotEmpty) {
            medidation = "Morning";
            meditationDetails = [
              MedicationModel(time: "Morning",medicationDetails: []),
              MedicationModel(time: "Noon",medicationDetails: []),
              MedicationModel(time: "Evening",medicationDetails: []),
            ];
            var medicationValues = jsonDecode(schedules.patientMedications!);
            medicationValues.keys.forEach((time) {
              List<dynamic> ?details = medicationValues[time];
              if(time == "Morning"){
                details?.forEach((element) {
                  (meditationDetails[0].medicationDetails ??= [])
                      .add(TextEditingController(text: element.toString()));
                });
              }
              if(time == "Noon"){
                details?.forEach((element) {
                  (meditationDetails[1].medicationDetails ??= [])
                      .add(TextEditingController(text: element.toString()));
                });
              }
              if(time == "Evening"){
                details?.forEach((element) {
                  (meditationDetails[2].medicationDetails ??= [])
                      .add(TextEditingController(text: element.toString()));
                });
              }
            });
            selectedMedication = medidation;
            debugPrint(medidation);
            update();
          }
          
          selectedOralCareTimings = _parseDynamicList(schedules.patientOralcare);
          selectedBathingTimings = _parseDynamicList(schedules.patientBathing);
          selectedDressingTimings = _parseDynamicList(schedules.patientDressing);
          update();

          if (schedules.patientLunchtime != null &&
              schedules.patientLunchtime!.isNotEmpty) {
            lunchFilters.clear();
            lunchFilters.add(schedules.patientLunchtime!);
            update();
          }
          if (schedules.patientHydration != null &&
              schedules.patientHydration!.isNotEmpty) {
            hydrationTEC.text = schedules.patientHydration!;
            update();
          }

          if (schedules.patientSnackstime != null &&
              schedules.patientSnackstime!.isNotEmpty) {
            snacks.clear();
            snacks.add(schedules.patientSnackstime!);
            update();
          }

          if (schedules.patientDinnertime != null &&
              schedules.patientDinnertime!.isNotEmpty) {
            dinner.clear();
            dinner.add(schedules.patientDinnertime!);
            update();
          }
          if (schedules.patientBloodsugar != null &&
              schedules.patientBloodsugar!.isNotEmpty) {
            bloodSugarTEC.text = schedules.patientBloodsugar!;
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
    update();
  }

  //
  ServiceHistory? serviceHistory;

  //
  loadGetHistory({int? appointmentId, int? patientId}) async {
    loadingServiceHistory = true;
    update();
    clearAllFields();
    try {
      String? token = await SharedPref().getToken();
      final uri = Uri.parse(URls().ServiceHistory).replace(queryParameters: {
        "appointment_id": appointmentId?.toString(),
        "patient_id": patientId?.toString(),
        "appointment_date": selectedDate.toString()
      });

      var res = await HttpService.instance.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        profile = ProfileList.fromJson(data);
        final schedules = profile?.data?.patientSchedules;
        if (schedules != null) {
          patientSchedules = schedules;
          pastSurgicalCT.text =
              schedules.patientPastsurgicalhistory ?? "";
          breakfastField.text = schedules.patientBreakfast ?? "";
          lunchField.text = schedules.patientLunch ?? "";
          snacksField.text = schedules.patientSnacks ?? "";
          dinnerField.text = schedules.patientDinner ?? "";
          lunchDetail = schedules.patientLunch ?? "";
          snacksDetail = schedules.patientSnacks ?? "";
          dinnerDetail = schedules.patientDinner ?? "";
          breakFastDetail = schedules.patientBreakfast ?? "";
          print(breakFastDetail);
          activityCT.text = schedules.patientActivitytype ?? "";
          toileting.text = schedules.patientToileting ?? "";
          temp.text = schedules.patientVitalsigns?.temperature ?? "";
          bp.text = schedules.patientVitalsigns?.bloodPressure ?? "";
          selectedWalkingTimings = _parseDynamicList(schedules.patientWalkingtime);
          print(selectedWalkingTimings);
          heartRate.text =
              schedules.patientVitalsigns?.heartRate?.toString() ?? "";
          respiration.text =
              schedules.patientVitalsigns?.respiratoryRate ?? "";

          ///
          if (schedules.patientBreakfasttime != null &&
              schedules.patientBreakfasttime!.isNotEmpty) {
            filters.clear();
            filters.add(schedules.patientBreakfasttime!);
          }

          if (schedules.patientMedications != null &&
              schedules.patientMedications!.isNotEmpty) {
            medidation = "Morning";
            meditationDetails = [
              MedicationModel(time: "Morning",medicationDetails: []),
              MedicationModel(time: "Noon",medicationDetails: []),
              MedicationModel(time: "Evening",medicationDetails: []),
            ];
            var medicationValues = jsonDecode(schedules.patientMedications!);
            medicationValues.keys.forEach((time) {
              List<dynamic> ?details = medicationValues[time];
              if(time == "Morning"){
                details?.forEach((element) {
                  (meditationDetails[0].medicationDetails ??= [])
                      .add(TextEditingController(text: element.toString()));
                });
              }
              if(time == "Noon"){
                details?.forEach((element) {
                  (meditationDetails[1].medicationDetails ??= [])
                      .add(TextEditingController(text: element.toString()));
                });
              }
              if(time == "Evening"){
                details?.forEach((element) {
                  (meditationDetails[2].medicationDetails ??= [])
                      .add(TextEditingController(text: element.toString()));
                });
              }
            });
            selectedMedication = medidation;
            debugPrint(medidation);
          }
          
          selectedOralCareTimings = _parseDynamicList(schedules.patientOralcare);
          selectedBathingTimings = _parseDynamicList(schedules.patientBathing);
          selectedDressingTimings = _parseDynamicList(schedules.patientDressing);

          if (schedules.patientLunchtime != null &&
              schedules.patientLunchtime!.isNotEmpty) {
            lunchFilters.clear();
            lunchFilters.add(schedules.patientLunchtime!);
          }
          if (schedules.patientHydration != null &&
              schedules.patientHydration!.isNotEmpty) {
            hydrationTEC.text = schedules.patientHydration!;
          }

          if (schedules.patientSnackstime != null &&
              schedules.patientSnackstime!.isNotEmpty) {
            snacks.clear();
            snacks.add(schedules.patientSnackstime!);
          }

          if (schedules.patientDinnertime != null &&
              schedules.patientDinnertime!.isNotEmpty) {
            dinner.clear();
            dinner.add(schedules.patientDinnertime!);
          }
          if (schedules.patientBloodsugar != null &&
              schedules.patientBloodsugar!.isNotEmpty) {
            bloodSugarTEC.text = schedules.patientBloodsugar!;
          }
          checkStatus();
        } else {
          debugPrint("No patient schedules found.");
        }
      } else {
        print('Failed to load history: ${res.statusCode}');
        fetchPrimaryInformationApi();
        isServiceComplete = false;
      }} catch (e) {
      debugPrint('Error: $e');
    }
    loadingServiceHistory = false;
    update();
  }

  //
  Future<void> postPatientHistory({int? appointmentId, int? patientId}) async {

    isLoading = true;
    update();
    final Map<String, dynamic> data = {
      "appointment_id": appointmentId,
      "patient_id": patientId,
      "patient_breakfasttime": patientSchedules?.patientBreakfasttime ?? "",
      "patient_breakfasttime_details": breakfastField.text,
      "patient_lunchtime": patientSchedules?.patientLunchtime ?? "",
      "patient_lunchtime_details": lunchField.text,
      "patient_snackstime": patientSchedules?.patientSnackstime ?? "",
      "patient_snackstime_details": snacksField.text,
      "patient_dinnertime": patientSchedules?.patientDinnertime ?? "",
      "patient_dinnertime_details": dinnerField.text,
      "patient_medications_details": {
        "Morning": meditationDetails.firstWhere((element) => element.time=="Morning", orElse: () => MedicationModel(time: "Morning", medicationDetails: [])).medicationDetails!.map((e) => e.text).toList(),
        "Noon": meditationDetails.firstWhere((element) => element.time=="Noon", orElse: () => MedicationModel(time: "Noon", medicationDetails: [])).medicationDetails!.map((e) => e.text).toList(),
        "Evening": meditationDetails.firstWhere((element) => element.time=="Evening", orElse: () => MedicationModel(time: "Evening", medicationDetails: [])).medicationDetails!.map((e) => e.text).toList()
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
      "appointment_date": selectedDate.toString(),
      "service_status": completeService ? 1:0
    };

    try {
      String? token = await SharedPref().getToken();
      final response = await HttpService.instance.post(
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
        getServiceStatus(patientId: patientId,appointmentId: appointmentId);
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
