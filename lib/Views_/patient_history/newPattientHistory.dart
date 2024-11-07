import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customButton.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/customToast.dart';
import 'package:care2caretaker/reuse_widgets/custom_textfield.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/PatientHistoryController.dart';
import 'customDrop.dart';
import 'customTimepickl.dart';

class NewPatientHistory extends StatefulWidget {
  int? appointmentId;
  int? patientId;

  NewPatientHistory({super.key, this.appointmentId, this.patientId});

  @override
  State<NewPatientHistory> createState() => _NewPatientHistoryState();
}

class _NewPatientHistoryState extends State<NewPatientHistory> {
  final PatientHistoryController controller =
      Get.put(PatientHistoryController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          CustomBackground(
            appBar: CustomAppBar(
              title: "Update Service Status",
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<PatientHistoryController>(
                  builder: (v) {
                    return Column(
                      children: [
                        CustomLabel(
                          text: "BreakFast",
                          color: AppColors.primaryColor,
                        ),
                        kHeight10,
                        CustomTimePicker(
                          label: 'BreakFast',
                          onTimeSelected: (TimeOfDay value) {
                            controller.breakfastTime = value;
                          },
                        ),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Breakfast Details',
                            hint: 'Enter Breakfast Details',
                            controller: controller.breakfastField),
                        kHeight10,
                        CustomLabel(
                          text: "Lunch",
                          color: AppColors.primaryColor,
                        ),
                        kHeight10,
                        CustomTimePicker(
                          label: 'Lunch',
                          onTimeSelected: (TimeOfDay value) {
                            controller.lunchTime = value;
                          },
                        ),
                        kHeight10,
                        customTextField(context,
                            labelText: '', controller: controller.lunchField),
                        kHeight10,
                        CustomLabel(
                          text: "Snacks",
                          color: AppColors.primaryColor,
                        ),
                        kHeight10,
                        CustomTimePicker(
                          label: 'Snacks',
                          onTimeSelected: (TimeOfDay value) {
                            controller.snacksTime = value;
                          },
                        ),
                        kHeight10,
                        customTextField(
                          context,
                          labelText: '',
                          controller: controller.snacksField,
                          color: AppColors.primaryColor,
                        ),
                        kHeight10,
                        CustomLabel(
                          text: "Dinner",
                          color: AppColors.primaryColor,
                        ),
                        kHeight10,
                        CustomTimePicker(
                          label: 'Dinner',
                          onTimeSelected: (TimeOfDay value) {
                            controller.dinnerTime = value;
                          },
                        ),
                        kHeight10,
                        customTextField(context,
                            labelText: '', controller: controller.dinnerField),
                        kHeight10,
                        CustomLabel(text: "Tube Feeding"),
                        kHeight10,
                        CustomDropdown(
                          selectedValue: controller.selectedPatient.isEmpty
                              ? null
                              : controller.selectedPatient,
                          items: controller.patients,
                          hint: 'Tube Feeding',
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedPatient =
                                  value;
                              controller.update();
                            }
                          },
                        ),
                        kHeight10,
                        CustomLabel(text: "Hydration"),
                        kHeight10,
                        CustomDropdown(
                          selectedValue: controller.selectedHydration.isEmpty
                              ? null
                              : controller.selectedHydration,
                          items: controller.hydration,
                          hint: 'Hydration',
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedHydration =
                                  value;
                              controller.update();
                            }
                          },
                        ),
                        kHeight10,
                        CustomLabel(text: "Oral Care"),
                        kHeight10,
                        CustomDropdown(
                          selectedValue: controller.selectOral.isEmpty
                              ? null
                              : controller.selectOral,
                          items: controller.oralList,
                          hint: 'Tube Feeding',
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectOral =
                                  value; // Use .value for reactive updates
                              controller.update();
                            }
                          },
                        ),
                        kHeight10,
                        CustomLabel(text: "Bathing"),
                        kHeight10,
                        CustomDropdown(
                          selectedValue: controller.selectBath.isEmpty
                              ? null
                              : controller.selectBath,
                          items: controller.Bathing,
                          hint: 'Tube Feeding',
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectBath =
                                  value; // Use .value for reactive updates
                              controller.update();

                            }
                          },
                        ),
                        kHeight10,
                        CustomLabel(text: "Medication"),
                        kHeight10,
                        CustomDropdown(
                          selectedValue: controller.selectMedication.isEmpty
                              ? null
                              : controller.selectMedication,
                          items: controller.Medication,
                          hint: 'Tube Feeding',
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectMedication =
                                  value; // Use .value for reactive updates
                              controller.update();

                            }
                          },
                        ),
                        kHeight10,
                        CustomLabel(text: "Medication Details"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Medication',
                            controller: controller.medicationCT),
                        kHeight10,
                        CustomLabel(text: "Toileting"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Toileting',
                            controller: controller.toiletingCT),
                        CustomLabel(text: "Temperature"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Temperature', controller: controller.TempCT),
                        CustomLabel(text: "Pulse"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Pulse', controller: controller.PulseCT),
                        CustomLabel(text: "Respirations"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Respirations',
                            controller: controller.Respirations),
                        CustomLabel(text: "Blood Sugar"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Blood Sugar',
                            controller: controller.BloodSugar),
                        CustomLabel(text: "Blood Pressure"),
                        kHeight10,
                        customTextField(context,
                            labelText: 'Blood Pressure',
                            controller: controller.BloodPressure),
                        kHeight55,
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
                child: CustomButton(
                  isLoading: controller.isLoading,
              text: "Submit",
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.rightSlide,
                  title: 'Are You Sure ',
                  desc: ' Once Submit service status will be completed',
                  btnCancelOnPress: () {
                    Get.back();
                  },
                  btnOkOnPress: () async {
                    controller.isLoading= true;
                    controller.update();
                    controller.postPatientHistory(
                        appointmentId: widget.appointmentId,
                        patientId: widget.patientId);
                    controller.isLoading= false;
                    controller.update();
Get.back();
                  },
                )..show();

              },
            )),
          ),
        ],
      ),
    );
  }
}
