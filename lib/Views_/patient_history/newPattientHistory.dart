import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customButton.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/custom_textfield.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../reuse_widgets/customChips.dart';
import '../../reuse_widgets/customradio.dart';
import '../schedule/controller/schedule_controller.dart';
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

  final PatientHistoryController controller = Get.put(PatientHistoryController());
  final sc = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
    sc.setInitialMedication();
    if(sc.patientID==null){
      sc.patientID = widget.patientId;
      sc.fetchPrimaryInformationApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          CustomBackground(
            appBar: CustomAppBar(
              leading: IconButton(
                  onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
              title: "Update Service Status",
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<ScheduleController>(
                  builder: (v) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            kHeight20,
                            kHeight15,
                            CustomLabel(
                              text: "Food Timing",
                              color: AppColors.primaryColor,
                            ),
                            kHeight15,
                            CustomLabel(text: "Break Fast"),
                            kHeight10,
                            Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: GetBuilder<ScheduleController>(
                                      init: sc,
                                      builder: (v) {
                                        String? selectedBreakfastTime =
                                            v.patientSchedules?.patientBreakfasttime;
                                        String? formattedSelectedBreakfastTime;
                                        if (selectedBreakfastTime != null) {
                                          final timeParts = selectedBreakfastTime.split(':');
                                          final hour = int.parse(timeParts[0]);
                                          final minute = timeParts[1];
                                          formattedSelectedBreakfastTime =
                                              (hour % 12).toString().padLeft(2, '0') +
                                                  '.' +
                                                  minute +
                                                  (hour < 12 ? ' AM' : ' PM');
                                        }

                                        return Wrap(
                                          spacing: 8.0,
                                          children: v.breakFast.map((String time) {
                                            bool isSelected =
                                                time == formattedSelectedBreakfastTime ||
                                                    v.filters.contains(time);
                                            return CustomChip(
                                              label: time,
                                              isSelected: isSelected,
                                              onSelected: (bool selected) {
                                                if (selected) {
                                                  v.filters.clear();
                                                  v.patientSchedules?.patientBreakfasttime =
                                                  null;
                                                  v.filters.add(time);
                                                  v.update();
                                                } else {
                                                  v.filters.remove(time);
                                                }
                                                // Update the controller and UI
                                                v.update();

                                              },
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            kHeight15,
                            customTextField(
                              context,
                              labelText: "Breakfast Detail",
                              hint: "Enter breakfast detail",
                              onChanged: (v){
                                sc.breakFastDetail = v!;
                              }
                            ),
                            kHeight15,
                            CustomLabel(text: "Lunch"),
                            kHeight15,
                            Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: GetBuilder<ScheduleController>(builder: (v) {
                                      String? selectedBreakfastTime =
                                          v.patientSchedules?.patientLunchtime;
                                      String? formattedSelectedBreakfastTime;
                                      if (selectedBreakfastTime != null) {
                                        final timeParts = selectedBreakfastTime.split(':');
                                        final hour = int.parse(timeParts[0]);
                                        final minute = timeParts[1];
                                        formattedSelectedBreakfastTime =
                                            (hour % 12).toString().padLeft(2, '0') +
                                                '.' +
                                                minute +
                                                (hour < 12 ? ' AM' : ' PM');
                                      }
                                      return Wrap(
                                        spacing: 8.0,
                                        children: v.lunchList.map((String name) {
                                          bool isSelected =
                                              name == formattedSelectedBreakfastTime ||
                                                  v.lunchFilters.contains(name);
                                          return CustomChip(
                                            label: name,
                                            isSelected: isSelected,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                if (selected) {
                                                  v.lunchFilters.clear();
                                                  v.patientSchedules!.patientLunchtime = null;
                                                  v.lunchFilters.add(name);
                                                } else {
                                                  v.lunchFilters.remove(name);
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            kHeight10,
                            customTextField(
                                context,
                                labelText: "Lunch Detail",
                                hint: "Enter lunch detail",
                                onChanged: (v){
                                  sc.lunchDetail = v!;
                                }
                            ),
                            kHeight15,
                            CustomLabel(text: "Snacks"),
                            kHeight10,
                            Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: GetBuilder<ScheduleController>(
                                        builder: (v) {
                                          String selectedSnackTime = v.patientSchedules
                                              ?.patientSnackstime?.isNotEmpty ==
                                              true
                                              ? v.patientSchedules!.patientSnackstime!
                                              : "06:00";

                                          String formattedSelectedSnackTime =
                                              "06:00";
                                          if (selectedSnackTime.contains(':')) {
                                            final timeParts = selectedSnackTime.split(':');
                                            if (timeParts.length == 2) {
                                              final hour = int.tryParse(timeParts[0]) ?? 0;
                                              final minute = timeParts[1];
                                              formattedSelectedSnackTime =
                                                  (hour % 12 == 0 ? 12 : hour % 12)
                                                      .toString()
                                                      .padLeft(2, '0') +
                                                      '.' +
                                                      minute +
                                                      (hour < 12 ? ' AM' : ' PM');
                                            }
                                          }

                                          return Wrap(
                                            spacing: 8.0,
                                            children: v.snackList.map((String name) {
                                              bool isSelected =
                                                  name == formattedSelectedSnackTime ||
                                                      v.snacks.contains(name);
                                              return CustomChip(
                                                label: name,
                                                isSelected: isSelected,
                                                onSelected: (bool selected) {
                                                  // Safely update snacks list
                                                  if (selected) {
                                                    v.snacks.clear();
                                                    v.snacks.add(name);
                                                    v.patientSchedules!.patientSnackstime =
                                                        name; // Update snack time
                                                    v.update(); // Rebuild GetX state
                                                  } else {
                                                    v.snacks.remove(name);
                                                    v.patientSchedules!.patientSnackstime =
                                                    null; // Clear snack time
                                                    v.update();
                                                  }
                                                },
                                              );
                                            }).toList(),
                                          );
                                        },
                                      )),
                                ),
                              ],
                            ),
                            kHeight10,
                            customTextField(
                                context,
                                labelText: "Snack Detail",
                                hint: "Enter snack detail",
                                onChanged: (v){
                                  sc.snacksDetail = v!;
                                }
                            ),
                            kHeight15,
                            CustomLabel(text: "Dinner"),
                            kHeight10,
                            Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: GetBuilder<ScheduleController>(builder: (v) {
                                      String? selectedBreakfastTime =
                                          v.patientSchedules?.patientDinnertime;
                                      String? formattedSelectedBreakfastTime;
                                      if (selectedBreakfastTime != null) {
                                        final timeParts = selectedBreakfastTime.split(':');
                                        final hour = int.parse(timeParts[0]);
                                        final minute = timeParts[1];
                                        formattedSelectedBreakfastTime =
                                            (hour % 12).toString().padLeft(2, '0') +
                                                '.' +
                                                minute +
                                                (hour < 12 ? ' AM' : ' PM');
                                      }
                                      return Wrap(
                                        spacing: 8.0,
                                        children: sc.dinnerList.map((String name) {
                                          bool isSelected =
                                              name == formattedSelectedBreakfastTime ||
                                                  v.dinner.contains(name);
                                          return CustomChip(
                                            label: name,
                                            isSelected: isSelected,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                if (selected) {
                                                  v.dinner.clear();
                                                  v.patientSchedules?.patientDinnertime =
                                                  null;
                                                  v.dinner.add(name);
                                                } else {
                                                  sc.dinner.remove(name);
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            kHeight10,
                            customTextField(
                                context,
                                labelText: "Dinner Detail",
                                hint: "Enter dinner detail",
                                onChanged: (v){
                                  sc.dinnerDetail = v!;
                                }
                            ),
                            kHeight15,
                            CustomLabel(text: "Hydration(Water)"),
                            kHeight10,
                            customTextField(context,
                                controller: sc.hydrationTEC, labelText: "Hydration"),
                            kHeight15,
                            CustomLabel(text: "Oral Care"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: [
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Morning',
                                              groupValue: sc.oralSelection,
                                              label: 'Morning',
                                              onChanged: (value) {
                                                sc.oralSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Noon',
                                              groupValue: sc.oralSelection,
                                              label: 'Noon',
                                              onChanged: (value) {
                                                sc.oralSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Evening',
                                              groupValue: sc.oralSelection,
                                              label: 'Evening',
                                              onChanged: (value) {
                                                sc.oralSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              );
                            }),
                            kHeight15,
                            CustomLabel(text: "Bathing"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: [
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Morning',
                                              groupValue: sc.bathingSelection,
                                              label: 'Morning',
                                              onChanged: (value) {
                                                sc.bathingSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Noon',
                                              groupValue: sc.bathingSelection,
                                              label: 'Noon',
                                              onChanged: (value) {
                                                sc.bathingSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Evening',
                                              groupValue: sc.bathingSelection,
                                              label: 'Evening',
                                              onChanged: (value) {
                                                sc.bathingSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              );
                            }),
                            kHeight15,
                            CustomLabel(text: "Medication"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: [
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Morning',
                                              groupValue: sc.medidation,
                                              label: 'Morning',
                                              onChanged: (value) {
                                                sc.medidation = value!;
                                                sc.selectedMedication = "Morning";
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Noon',
                                              groupValue: sc.medidation,
                                              label: 'Noon',
                                              onChanged: (value) {
                                                sc.medidation = value!;
                                                sc.selectedMedication = "Noon";
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Evening',
                                              groupValue: sc.medidation,
                                              label: 'Evening',
                                              onChanged: (value) {
                                                sc.medidation = value!;
                                                sc.selectedMedication = "Evening";
                                                sc.update();
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              );
                            }),
                            GetBuilder<ScheduleController>(
                                builder: (v){
                                  return sc.selectedMedication!=null
                                      ? Column(
                                    children: [

                                      kHeight15,

                                      ListView.builder(
                                          itemCount: sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails!.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Padding(
                                              padding: EdgeInsets.only(top: 16.h),
                                              child: Row(
                                                children: [

                                                  Expanded(
                                                    flex: 3,
                                                    child: customTextField(
                                                        context,
                                                        controller: sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails![index],
                                                        hint: "Enter details",
                                                        labelText: "${sc.selectedMedication!} medication ${index+1}"
                                                    ),
                                                  ),

                                                  Expanded(
                                                      flex: 1,
                                                      child: IconButton(
                                                        onPressed: (){
                                                          sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails!.removeAt(index);
                                                          sc.update();
                                                        },
                                                        icon: Icon(Icons.remove),
                                                      )),

                                                ],
                                              ),
                                            );
                                          }),

                                      kHeight15,

                                      CustomButton(
                                          onPressed: (){
                                            sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails!.add(TextEditingController());
                                            sc.update();
                                          },
                                          text: "Add medication detail"
                                      ),

                                    ],
                                  ) : SizedBox();
                                }
                            ),
                            kHeight15,
                            CustomLabel(text: "Dressing"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: [
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Morning',
                                              groupValue: sc.dressingSelection,
                                              label: 'Morning',
                                              onChanged: (value) {
                                                sc.dressingSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Noon',
                                              groupValue: sc.dressingSelection,
                                              label: 'Noon',
                                              onChanged: (value) {
                                                sc.dressingSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Evening',
                                              groupValue: sc.dressingSelection,
                                              label: 'Evening',
                                              onChanged: (value) {
                                                sc.dressingSelection = value!;
                                                sc.update();
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              );
                            }),
                            kHeight15,
                            CustomLabel(text: "Toileting"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return TextField(
                                controller: v.toileting,
                                decoration: InputDecoration(
                                  //filled: true,
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.black, width: 0.3),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.black, width: 0.3),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.black, width: 0.3),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintStyle: const TextStyle(color: Colors.grey),
                                ),
                              );
                            }),
                            kHeight15,
                            CustomLabel(text: "Walking"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: [
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Morning',
                                              groupValue: sc.walkingTime,
                                              label: 'Morning',
                                              onChanged: (value) {
                                                sc.walkingTime = value!;
                                                sc.update();
                                              },
                                            ),
                                            kWidth10,
                                            CustomRadioButton(
                                              selectedColor: AppColors.primaryColor,
                                              unselectedColor: Colors.white,
                                              value: 'Evening',
                                              groupValue: sc.walkingTime,
                                              label: 'Evening',
                                              onChanged: (value) {
                                                sc.walkingTime = value!;
                                                sc.update();
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              );
                            }),
                            kHeight15,
                            CustomLabel(text: "Baseline Vital Signs"),
                            kHeight10,
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                        child: customTextField(context,
                                            controller: sc.temp, labelText: "Temperature")),
                                    kWidth10,
                                    Expanded(
                                        child: customTextField(context,
                                            labelText: "Pulse", controller: sc.heartRate)),
                                    kWidth10,
                                    Expanded(
                                        child: customTextField(context,
                                            controller: sc.respiration,
                                            labelText: "Respirations")),
                                    kWidth10,
                                    Expanded(
                                        child: customTextField(context,
                                            controller: sc.bp, labelText: "BP")),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            kHeight15,
                            CustomLabel(text: "Blood Sugar"),
                            kHeight10,
                            GetBuilder<ScheduleController>(builder: (v) {
                              return customTextField(context,
                                  controller: sc.bloodSugarTEC, labelText: "Blood Sugar");
                            }),
                            kHeight10,
                            kHeight15,
                            kHeight15,
                            kHeight15,
                            kHeight15,

                          ],
                        ),
                      ),
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
