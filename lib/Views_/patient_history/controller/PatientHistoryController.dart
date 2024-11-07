import 'dart:convert';

import 'package:care2caretaker/api_urls/url.dart';
import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../reuse_widgets/customToast.dart';

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

  bool isLoading = false;

  String _timeToString(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // Return formatted string
    return '${formattedTime.hour}:${formattedTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> postPatientHistory({int? appointmentId, int? patientId}) async {
    isLoading = true;
    update();

    final Map<String, dynamic> data = {
      "appointment_id": appointmentId,
      "patient_id": patientId,
      "patient_breakfasttime": _timeToString(breakfastTime),
      "patient_breakfasttime_details": breakfastField.text,
      "patient_lunchtime": _timeToString(lunchTime),
      "patient_lunchtime_details": lunchField.text,
      "patient_snackstime": _timeToString(snacksTime),
      "patient_snackstime_details": snacksField.text,
      "patient_dinnertime": _timeToString(dinnerTime),
      "patient_dinnertime_details": dinnerField.text,
      "patient_medications": selectMedication,
      "patient_medications_details": medicationCT.text,
      "patient_hydration": selectedHydration,
      "patient_oralcare": selectOral,
      "patient_bathing": selectBath,
      "patient_dressing": selectDressing,
      "patient_toileting": toiletingCT.text,
      "patient_walkingtime": '',
      "patient_vitalsigns": {
        "blood_pressure": BloodPressure.text,
        "heart_rate": PulseCT.text,
        "respiratory_rate": Respirations.text,
        "temperature": TempCT.text,
        "weight": 70
      },
      "patient_bloodsugar": BloodSugar.text
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
