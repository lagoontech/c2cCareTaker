import 'package:flutter/cupertino.dart';

class MedicationModel {

  MedicationModel({
    this.time,
    this.medicationDetails,

});

  String ?time;
  List<TextEditingController> ?medicationDetails;
}