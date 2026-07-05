import 'package:care2caretaker/Utils/null_safe_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:care2caretaker/Views_/patient_history/Models/service_status_model.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customButton.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/custom_textfield.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/loader.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../reuse_widgets/customChips.dart';
import '../../reuse_widgets/customradio.dart';
import '../../sharedPref/sharedPref.dart';
import '../schedule/modal/medication_model.dart';
import 'controller/PatientHistoryController.dart';

class NewPatientHistory extends StatefulWidget {
  int? appointmentId;
  int? patientId;
  List<DateTime>? appointmentDates;

  NewPatientHistory(
      {super.key, this.appointmentId, this.patientId, this.appointmentDates});

  @override
  State<NewPatientHistory> createState() => _NewPatientHistoryState();
}

class _NewPatientHistoryState extends State<NewPatientHistory> {
  final PatientHistoryController sc = Get.put(PatientHistoryController());
  //final scheduleController = Get.put(ScheduleController());

  final TextEditingController breakfastTimeController = TextEditingController();
  final TextEditingController lunchTimeController = TextEditingController();
  final TextEditingController snacksTimeController = TextEditingController();
  final TextEditingController dinnerTimeController = TextEditingController();

  DateTime get _calendarStart =>
      NullSafe.firstDate(widget.appointmentDates) ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    sc.setInitialMedication();
    if (sc.patientID == null) {
      sc.patientID = widget.patientId;
      sc.selectedDate = NullSafe.firstDate(widget.appointmentDates) ?? DateTime.now();
      sc.loadGetHistory(
          appointmentId: widget.appointmentId, patientId: widget.patientId);
      sc.getServiceStatus(
          appointmentId: widget.appointmentId, patientId: widget.patientId);
    }
  }

  @override
  void dispose() {
    breakfastTimeController.dispose();
    lunchTimeController.dispose();
    snacksTimeController.dispose();
    dinnerTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          CustomBackground(
            appBar: CustomAppBar(
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios)),
              title: "Service Status",
              actions: [
                IconButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Appointment Dates",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  kHeight15,
                                  TableCalendar(
                                    focusedDay: _calendarStart,
                                    headerStyle: HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true,
                                    ),
                                    calendarStyle: CalendarStyle(
                                      outsideDaysVisible: false,
                                    ),
                                    calendarBuilders: CalendarBuilders(
                                      defaultBuilder: (context, date, _) {
                                        bool isAppointmentDate = false;
                                        widget.appointmentDates
                                            ?.forEach((element) {
                                          if (DateFormat("MMM dd")
                                                  .format(element) ==
                                              DateFormat("MMM dd")
                                                  .format(date)) {
                                            isAppointmentDate = true;
                                          }
                                        });
                                        String status = "";
                                        if (isAppointmentDate) {
                                          status = sc.statuses
                                              .firstWhere((element) {
                                                final parsedDate =
                                                    DateTime.tryParse(
                                                        element.serviceDate ??
                                                            "");
                                                return parsedDate != null &&
                                                    DateFormat("MMM dd").format(
                                                            parsedDate) ==
                                                        DateFormat("MMM dd")
                                                            .format(date);
                                              },
                                                  orElse: () =>
                                                      ServiceStatusModel(
                                                          status: 0))
                                              .status
                                              .toString();
                                        }
                                        Color? cellColor;
                                        if (status == '1') {
                                          cellColor = Colors.green;
                                        } else if (status == '0') {
                                          cellColor = AppColors.primaryColor;
                                        }

                                        return Container(
                                          margin: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                cellColor ?? Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${date.day}',
                                            style: TextStyle(
                                                color: status == 1
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        );
                                      },
                                    ),
                                    firstDay: _calendarStart,
                                    lastDay: DateTime(2050),
                                  ),
                                  CustomButton(
                                    text: "Close",
                                    onPressed: () {
                                      Get.back();
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.calendar_month))
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<PatientHistoryController>(builder: (v) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomLabel(
                            text: "Appointment Date",
                            color: AppColors.primaryColor,
                          ),
                          kHeight10,
                          DropdownButtonFormField(
                              value: sc.selectedDate,
                              items: (widget.appointmentDates ?? [])
                                  .map((e) => DropdownMenuItem(
                                        child: Text(
                                            DateFormat("MMM dd").format(e)),
                                        value: e,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: v.isServiceComplete
                                      ? Icon(Icons.check, color: Colors.green)
                                      : Icon(Icons.pending),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade500,
                                          width: 1),
                                      borderRadius:
                                          BorderRadius.circular(12.r)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade500,
                                          width: 1),
                                      borderRadius:
                                          BorderRadius.circular(12.r)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade500,
                                          width: 1),
                                      borderRadius:
                                          BorderRadius.circular(12.r))),
                              onChanged: (v) {
                                sc.selectedDate = v;
                                sc.loadGetHistory(
                                    appointmentId: widget.appointmentId,
                                    patientId: widget.patientId);
                                sc.checkStatus();
                              }),
                          kHeight15,
                          GetBuilder<PatientHistoryController>(builder: (vc) {
                            breakfastTimeController.text = formatTime(
                                vc.patientSchedules?.patientBreakfasttime ??
                                    "");
                            lunchTimeController.text = formatTime(
                                vc.patientSchedules?.patientLunchtime ?? "");
                            snacksTimeController.text = formatTime(
                                vc.patientSchedules?.patientSnackstime ?? "");
                            dinnerTimeController.text = formatTime(
                                vc.patientSchedules?.patientDinnertime ?? "");
                            return vc.loadingServiceHistory
                                ? CircularProgressIndicator(
                                    color: AppColors.primaryColor)
                                : Column(
                                    children: [
                                      kHeight15,
                                      CustomLabel(
                                        text: "Food Timing",
                                        color: AppColors.primaryColor,
                                      ),
                                      kHeight15,
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: customTextField(context,
                                                readOnly: true,
                                                fontSize: 12.sp,
                                                controller:
                                                    breakfastTimeController,
                                                labelText: "Breakfast Time",
                                                hint: "Select Time",
                                                maxLines: 1,
                                                suffix: Icon(Icons.access_time,
                                                    size: 20.sp,
                                                    color:
                                                        AppColors.primaryColor),
                                                onTap: () async {
                                              final result =
                                                  await showTimePickerDialog(
                                                      context);
                                              if (result != null &&
                                                  result
                                                      .toString()
                                                      .isNotEmpty) {
                                                vc.patientSchedules
                                                        ?.patientBreakfasttime =
                                                    result;
                                                vc.filters.clear();
                                                vc.filters.add(result);
                                                vc.update();
                                              }
                                            }),
                                          ),
                                          kWidth10,
                                          Expanded(
                                            flex: 3,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                controller: sc.breakfastField,
                                                labelText: "Breakfast Detail",
                                                hint: "Enter breakfast detail",
                                                maxLines: 1, onChanged: (v) {
                                              sc.breakFastDetail = v ?? '';
                                            }),
                                          ),
                                        ],
                                      ),
                                      kHeight10,
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                readOnly: true,
                                                controller: lunchTimeController,
                                                labelText: "Lunch Time",
                                                hint: "Select Time",
                                                maxLines: 1,
                                                suffix: Icon(Icons.access_time,
                                                    size: 20.sp,
                                                    color:
                                                        AppColors.primaryColor),
                                                onTap: () async {
                                              final result =
                                                  await showTimePickerDialog(
                                                      context);
                                              if (result != null &&
                                                  result
                                                      .toString()
                                                      .isNotEmpty) {
                                                vc.patientSchedules
                                                    ?.patientLunchtime = result;
                                                vc.lunchFilters.clear();
                                                vc.lunchFilters.add(result);
                                                vc.update();
                                              }
                                            }),
                                          ),
                                          kWidth10,
                                          Expanded(
                                            flex: 3,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                controller: sc.lunchField,
                                                labelText: "Lunch Detail",
                                                hint: "Enter lunch detail",
                                                maxLines: 1, onChanged: (v) {
                                              sc.lunchDetail = v ?? '';
                                            }),
                                          ),
                                        ],
                                      ),
                                      kHeight10,
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                readOnly: true,
                                                controller:
                                                    snacksTimeController,
                                                labelText: "Snack Time",
                                                hint: "Select Time",
                                                maxLines: 1,
                                                suffix: Icon(Icons.access_time,
                                                    size: 20.sp,
                                                    color:
                                                        AppColors.primaryColor),
                                                onTap: () async {
                                              final result =
                                                  await showTimePickerDialog(
                                                      context);
                                              if (result != null &&
                                                  result
                                                      .toString()
                                                      .isNotEmpty) {
                                                vc.patientSchedules
                                                        ?.patientSnackstime =
                                                    result;
                                                vc.snacks.clear();
                                                vc.snacks.add(result);
                                                vc.update();
                                              }
                                            }),
                                          ),
                                          kWidth10,
                                          Expanded(
                                            flex: 3,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                controller: sc.snacksField,
                                                labelText: "Snack Detail",
                                                hint: "Enter snack detail",
                                                maxLines: 1, onChanged: (v) {
                                              sc.snacksDetail = v ?? '';
                                            }),
                                          ),
                                        ],
                                      ),
                                      kHeight10,
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                readOnly: true,
                                                controller:
                                                    dinnerTimeController,
                                                labelText: "Dinner Time",
                                                hint: "Select Time",
                                                maxLines: 1,
                                                suffix: Icon(Icons.access_time,
                                                    size: 20.sp,
                                                    color:
                                                        AppColors.primaryColor),
                                                onTap: () async {
                                              final result =
                                                  await showTimePickerDialog(
                                                      context);
                                              if (result != null &&
                                                  result
                                                      .toString()
                                                      .isNotEmpty) {
                                                vc.patientSchedules
                                                        ?.patientDinnertime =
                                                    result;
                                                vc.dinner.clear();
                                                vc.dinner.add(result);
                                                vc.update();
                                              }
                                            }),
                                          ),
                                          kWidth10,
                                          Expanded(
                                            flex: 3,
                                            child: customTextField(context,
                                                fontSize: 12.sp,
                                                controller: sc.dinnerField,
                                                labelText: "Dinner Detail",
                                                hint: "Enter dinner detail",
                                                maxLines: 1, onChanged: (v) {
                                              sc.dinnerDetail = v ?? '';
                                            }),
                                          ),
                                        ],
                                      ),
                                      kHeight15,
                                      CustomLabel(text: "Hydration(Water)"),
                                      kHeight10,
                                      customTextField(context,
                                          fontSize: 12.sp,
                                          controller: sc.hydrationTEC,
                                          labelText: "Hydration"),
                                      kHeight15,
                                      CustomLabel(text: "Oral Care"),
                                      kHeight10,
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Wrap(
                                                    children: [
                                                      CustomChip(
                                                        label: "Morning",
                                                        isSelected: sc
                                                            .selectedOralCareTimings
                                                            .contains(
                                                                "Morning"),
                                                        onSelected:
                                                            (bool selected) {
                                                          print(selected);
                                                          if (selected) {
                                                            sc.selectedOralCareTimings
                                                                .add("Morning");
                                                          } else {
                                                            sc.selectedOralCareTimings
                                                                .remove(
                                                                    "Morning");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Noon",
                                                        isSelected: sc
                                                            .selectedOralCareTimings
                                                            .contains("Noon"),
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            sc.selectedOralCareTimings
                                                                .add("Noon");
                                                          } else {
                                                            sc.selectedOralCareTimings
                                                                .remove("Noon");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Evening",
                                                        isSelected: sc
                                                            .selectedOralCareTimings
                                                            .contains(
                                                                "Evening"),
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            sc.selectedOralCareTimings
                                                                .add("Evening");
                                                          } else {
                                                            sc.selectedOralCareTimings
                                                                .remove(
                                                                    "Evening");
                                                          }
                                                          v.update();
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
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Wrap(
                                                    children: [
                                                      CustomChip(
                                                        label: "Morning",
                                                        isSelected: sc
                                                            .selectedBathingTimings
                                                            .contains(
                                                                "Morning"),
                                                        onSelected:
                                                            (bool selected) {
                                                          print(selected);
                                                          if (selected) {
                                                            sc.selectedBathingTimings
                                                                .add("Morning");
                                                          } else {
                                                            sc.selectedBathingTimings
                                                                .remove(
                                                                    "Morning");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Noon",
                                                        isSelected: sc
                                                            .selectedBathingTimings
                                                            .contains("Noon"),
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            sc.selectedBathingTimings
                                                                .add("Noon");
                                                          } else {
                                                            sc.selectedBathingTimings
                                                                .remove("Noon");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Evening",
                                                        isSelected: sc
                                                            .selectedBathingTimings
                                                            .contains(
                                                                "Evening"),
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            sc.selectedBathingTimings
                                                                .add("Evening");
                                                          } else {
                                                            sc.selectedBathingTimings
                                                                .remove(
                                                                    "Evening");
                                                          }
                                                          v.update();
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
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Wrap(
                                                    children: [
                                                      CustomRadioButton(
                                                        selectedColor: AppColors
                                                            .primaryColor,
                                                        unselectedColor:
                                                            Colors.white,
                                                        value: 'Morning',
                                                        groupValue:
                                                            sc.medidation,
                                                        label: 'Morning',
                                                        onChanged: (value) {
                                                          sc.medidation =
                                                              value!;
                                                          sc.selectedMedication =
                                                              "Morning";
                                                          sc.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomRadioButton(
                                                        selectedColor: AppColors
                                                            .primaryColor,
                                                        unselectedColor:
                                                            Colors.white,
                                                        value: 'Noon',
                                                        groupValue:
                                                            sc.medidation,
                                                        label: 'Noon',
                                                        onChanged: (value) {
                                                          sc.medidation =
                                                              value!;
                                                          sc.selectedMedication =
                                                              "Noon";
                                                          sc.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomRadioButton(
                                                        selectedColor: AppColors
                                                            .primaryColor,
                                                        unselectedColor:
                                                            Colors.white,
                                                        value: 'Evening',
                                                        groupValue:
                                                            sc.medidation,
                                                        label: 'Evening',
                                                        onChanged: (value) {
                                                          sc.medidation =
                                                              value!;
                                                          sc.selectedMedication =
                                                              "Evening";
                                                          sc.update();
                                                        },
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        );
                                      }),
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return sc.selectedMedication != null
                                            ? Column(
                                                children: [
                                                  kHeight15,
                                                  ListView.builder(
                                                      itemCount: sc
                                                          .meditationDetails
                                                          .firstWhere((element) =>
                                                              element.time ==
                                                              sc
                                                                  .selectedMedication!)
                                                          .medicationDetails!
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16.h),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child: customTextField(
                                                                    fontSize:
                                                                        12.sp,
                                                                    context,
                                                                    controller: () {
                                                                      final slot = sc.meditationDetails.firstWhere(
                                                                          (element) => element.time == sc.selectedMedication,
                                                                          orElse: () => MedicationModel(
                                                                              time: sc.selectedMedication ?? '',
                                                                              medicationDetails: []));
                                                                      final meds = slot.medicationDetails;
                                                                      if (meds != null && index < meds.length) {
                                                                        return meds[index];
                                                                      }
                                                                      return TextEditingController();
                                                                    }(),
                                                                    hint: "Enter details",
                                                                    labelText: "${sc.selectedMedication!} medication ${index + 1}"),
                                                              ),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      sc.meditationDetails
                                                                          .firstWhere((element) =>
                                                                              element.time ==
                                                                              sc.selectedMedication!)
                                                                          .medicationDetails!
                                                                          .removeAt(index);
                                                                      sc.update();
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .remove),
                                                                  )),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                  kHeight15,
                                                  sc.isServiceComplete
                                                      ? SizedBox()
                                                      : CustomButton(
                                                          onPressed: () {
                                                            sc.meditationDetails
                                                                .firstWhere((element) =>
                                                                    element
                                                                        .time ==
                                                                    sc.selectedMedication!)
                                                                .medicationDetails!
                                                                .add(TextEditingController());
                                                            sc.update();
                                                          },
                                                          text:
                                                              "Add medication detail"),
                                                ],
                                              )
                                            : SizedBox();
                                      }),
                                      kHeight15,
                                      CustomLabel(text: "Dressing"),
                                      kHeight10,
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Wrap(
                                                    children: [
                                                      CustomChip(
                                                        label: "Morning",
                                                        isSelected: sc
                                                            .selectedDressingTimings
                                                            .contains(
                                                                "Morning"),
                                                        onSelected:
                                                            (bool selected) {
                                                          print(selected);
                                                          if (selected) {
                                                            sc.selectedDressingTimings
                                                                .add("Morning");
                                                          } else {
                                                            sc.selectedDressingTimings
                                                                .remove(
                                                                    "Morning");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Noon",
                                                        isSelected: sc
                                                            .selectedDressingTimings
                                                            .contains("Noon"),
                                                        onSelected:
                                                            (bool selected) {
                                                          print(selected);
                                                          if (selected) {
                                                            sc.selectedDressingTimings
                                                                .add("Noon");
                                                          } else {
                                                            sc.selectedDressingTimings
                                                                .remove("Noon");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Evening",
                                                        isSelected: sc
                                                            .selectedDressingTimings
                                                            .contains(
                                                                "Evening"),
                                                        onSelected:
                                                            (bool selected) {
                                                          print(selected);
                                                          if (selected) {
                                                            sc.selectedDressingTimings
                                                                .add("Evening");
                                                          } else {
                                                            sc.selectedDressingTimings
                                                                .remove(
                                                                    "Evening");
                                                          }
                                                          v.update();
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
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return TextField(
                                          controller: v.toileting,
                                          decoration: InputDecoration(
                                            //filled: true,
                                            focusColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        );
                                      }),
                                      kHeight15,
                                      CustomLabel(text: "Walking"),
                                      kHeight10,
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Wrap(
                                                    children: [
                                                      CustomChip(
                                                        label: "Morning",
                                                        isSelected: sc
                                                            .selectedWalkingTimings
                                                            .contains(
                                                                "Morning"),
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            sc.selectedWalkingTimings
                                                                .add("Morning");
                                                          } else {
                                                            sc.selectedWalkingTimings
                                                                .remove(
                                                                    "Morning");
                                                          }
                                                          v.update();
                                                        },
                                                      ),
                                                      kWidth10,
                                                      CustomChip(
                                                        label: "Evening",
                                                        isSelected: sc
                                                            .selectedWalkingTimings
                                                            .contains(
                                                                "Evening"),
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            sc.selectedWalkingTimings
                                                                .add("Evening");
                                                          } else {
                                                            sc.selectedWalkingTimings
                                                                .remove(
                                                                    "Evening");
                                                          }
                                                          v.update();
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
                                                  child: customTextField(
                                                      fontSize: 12.sp,
                                                      context,
                                                      controller: sc.temp,
                                                      labelText:
                                                          "Temperature")),
                                              kWidth10,
                                              Expanded(
                                                  child: customTextField(
                                                      fontSize: 12.sp,
                                                      context,
                                                      labelText: "Pulse",
                                                      controller:
                                                          sc.heartRate)),
                                              kWidth10,
                                              Expanded(
                                                  child: customTextField(
                                                      fontSize: 12.sp,
                                                      context,
                                                      controller:
                                                          sc.respiration,
                                                      labelText:
                                                          "Respirations")),
                                              kWidth10,
                                              Expanded(
                                                  child: customTextField(
                                                      fontSize: 12.sp,
                                                      context,
                                                      controller: sc.bp,
                                                      labelText: "BP")),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                      kHeight15,
                                      CustomLabel(text: "Blood Sugar"),
                                      kHeight10,
                                      GetBuilder<PatientHistoryController>(
                                          builder: (v) {
                                        return customTextField(context,
                                            fontSize: 12.sp,
                                            controller: sc.bloodSugarTEC,
                                            labelText: "Blood Sugar");
                                      }),
                                    ],
                                  );
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
                }),
              ),
            ),
          ),
          GetBuilder<PatientHistoryController>(builder: (vc) {
            return sc.isServiceComplete
                ? SizedBox()
                : Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      height: kToolbarHeight,
                      child: Center(
                          child: Row(
                        children: [
                          GetBuilder<PatientHistoryController>(builder: (vc) {
                            return Expanded(
                              child: CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    "Complete service",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  value: sc.completeService,
                                  onChanged: (v) {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'You are about to complete the service for the day',
                                      desc:
                                          'You will not be able to edit it further',
                                      btnCancelOnPress: () {
                                        sc.completeService = false;
                                        sc.update();
                                      },
                                      btnOkOnPress: () async {
                                        sc.completeService = true;
                                        sc.update();
                                      },
                                    )..show();
                                  }),
                            );
                          }),
                          Expanded(
                            child: CustomButton(
                              isLoading: sc.isLoading,
                              text: "Save",
                              onPressed: () {
                                sc.isLoading = true;
                                sc.update();
                                sc.postPatientHistory(
                                    appointmentId: widget.appointmentId,
                                    patientId: widget.patientId);
                                sc.isLoading = false;
                                sc.update();
                              },
                            ),
                          ),
                        ],
                      )),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    try {
      if (time.contains("AM") || time.contains("PM")) {
        return time;
      }
      if (time.contains(":")) {
        final parts = time.split(":");
        if (parts.length != 2) return "";
        final hour = int.tryParse(parts[0]);
        final minute = parts[1];
        if (hour == null) return "";
        final hour12 = hour % 12 == 0 ? 12 : hour % 12;
        final period = hour < 12 ? "AM" : "PM";
        return "${hour12.toString().padLeft(2, '0')}:$minute $period";
      }
      return "--";
    } catch (e) {
      return "--";
    }
  }

  Future<dynamic> showTimePickerDialog(BuildContext context) async {
    var result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null && result is TimeOfDay) {
      return "${result.hourOfPeriod.toString().padLeft(2, '0')}.${result.minute.toString().padLeft(2, '0')} ${result.period == DayPeriod.am ? 'AM' : 'PM'}";
    }
    return "";
  }
}

class MealTimeCard extends StatelessWidget {
  final String title;
  final String icon;
  final String? time;
  final VoidCallback onTap;

  const MealTimeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.w),
          color: AppColors.primaryColor.withOpacity(0.08),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontSize: 22.sp)),
            SizedBox(height: 6.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              time == null || time == "--" || time == ""
                  ? "Select Time"
                  : time!,
              style: TextStyle(
                color: time == null || time == "--" || time == ""
                    ? Colors.grey
                    : AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
