import 'dart:convert';
import 'dart:io';
import 'package:care2caretaker/Utils/http_service.dart';
import 'package:care2caretaker/api_urls/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import '../../../reuse_widgets/customToast.dart';
import '../../../sharedPref/sharedPref.dart';
import '../../HomeView/home_view.dart';
import '../../PatientRequest/modal/patientRequest_modal.dart' hide PatientSchedules;
import '../modal/medication_model.dart';
import '../../Profile/modal/profile_model.dart';

class ScheduleController extends GetxController {

  final List<String> filters = [];
  final List<String> lunchFilters = [];
  final List<String> snacks = [];
  final List<String> dinner = [];
  List<String> meditations = [];
  List<MedicationModel> meditationDetails = [];
  String ?selectedMedication;
  final List<String> hydration = [];
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
  var selectedHydration = "";
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

  //var item = [DropdownItem(label: "sujin", value: 3)];
  PatientSchedules? patientSchedules;

  // Common variables
  String? token;
  int? patientID;
  ProfileList? profile;

  bool updating = false;
  bool isLoading  = false;
  bool inserting = false;

  //
  Future<void> fetchCommonDetails() async {
    token = await SharedPref().getToken();
    String? patientIDStr = await SharedPref().getId();
    if (patientIDStr != null) {
      patientID = int.parse(patientIDStr);
    }
  }

  // Helper function to format time
  String formatTime(String time) {
    final parts = time.split(' ');
    if (parts.length != 2)
      return time;
    final timeParts = parts[0].split('.');

    int hours = int.parse(timeParts[0]);
    final minutes = '00';

    if (parts[1] == 'PM' && hours < 12) {
      hours += 12;
    } else if (parts[1] == 'AM' && hours == 12) {
      hours = 0;
    }

    return '${hours.toString().padLeft(2, '0')}:${minutes}';
  }

  //
  Future<void> postPatientHistory({int? appointmentId, int? patientId}) async {

    isLoading = true;
    update();
    final Map<String, dynamic> data = {
      "appointment_id": appointmentId,
      "patient_id": patientId,
      "patient_breakfasttime": patientSchedules?.patientBreakfasttime,
      "patient_breakfasttime_details": breakFastDetail,
      "patient_lunchtime": patientSchedules?.patientLunchtime,
      "patient_lunchtime_details": lunchDetail,
      "patient_snackstime": patientSchedules?.patientSnackstime,
      "patient_snackstime_details": snacksDetail,
      "patient_dinnertime": patientSchedules?.patientDinnertime,
      "patient_dinnertime_details": dinnerDetail,
      "patient_medications_details": {
         "Morning": meditationDetails.firstWhere((element) => element.time=="Morning", orElse: () => MedicationModel(time: "Morning", medicationDetails: [])).medicationDetails?.map((e) => e.text).toList() ?? [],
         "Noon": meditationDetails.firstWhere((element) => element.time=="Noon", orElse: () => MedicationModel(time: "Noon", medicationDetails: [])).medicationDetails?.map((e) => e.text).toList() ?? [],
         "Evening": meditationDetails.firstWhere((element) => element.time=="Evening", orElse: () => MedicationModel(time: "Evening", medicationDetails: [])).medicationDetails?.map((e) => e.text).toList() ?? []
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
      } else {
        print("Failed to submit data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoading = false;
    update();

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
  Future<void> fetchPrimaryInformationApi() async {
      try {
    String? token = await SharedPref().getToken();
    String? patientIDStr = await SharedPref().getId();

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
            schedules.patientPastsurgicalhistory?.toString() ?? '';
        activityCT.text = schedules.patientActivitytype ?? '';
        toileting.text = schedules.patientToileting ?? '';
        temp.text = schedules.patientVitalsigns?.temperature ?? '';
        bp.text = schedules.patientVitalsigns?.bloodPressure ?? '';
        selectedWalkingTimings = schedules.patientWalkingtime != null
            ? jsonDecode(schedules.patientWalkingtime!)
            : [];
        heartRate.text =
            schedules.patientVitalsigns?.heartRate?.toString() ?? '';
        respiration.text =
            schedules.patientVitalsigns?.respiratoryRate ?? '';

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
        if (schedules.patientOralcare != null &&
            schedules.patientOralcare!.isNotEmpty) {
          //oralSelection = schedules.patientOralcare!;
          selectedOralCareTimings = jsonDecode(schedules.patientOralcare!);
          debugPrint(medidation);
          update();
        }
        if (schedules.patientBathing != null &&
            schedules.patientBathing!.isNotEmpty) {
          //bathingSelection = schedules.patientBathing!;
          selectedBathingTimings = jsonDecode(schedules.patientBathing!);

          debugPrint(medidation);
          update();
        }
        if (schedules.patientDressing != null &&
            schedules.patientDressing!.isNotEmpty) {
          //dressingSelection = schedules.patientDressing!;
          selectedDressingTimings = jsonDecode(schedules.patientDressing!);
          debugPrint(medidation);
          update();
        }

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
  }

  //
  @override
  void onInit() {
    fetchPrimaryInformationApi();
    fetchCommonDetails();
    super.onInit();
  }

  //
  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }
}
