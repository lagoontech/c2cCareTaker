import 'package:care2caretaker/Views_/patient_history/Patient%20History/Controller/completed_appointment_details_controller.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../reuse_widgets/AppColors.dart';
import '../../../reuse_widgets/image_background.dart';

class CompletedAppointmentDetails extends StatelessWidget {
  CompletedAppointmentDetails({super.key, this.appointmentDates, this.appointmentId, this.patientId});

  List<DateTime>? appointmentDates;
  int? appointmentId;
  int? patientId;

  CompletedAppointmentDetailsController sc = Get.put(CompletedAppointmentDetailsController());

  @override
  Widget build(BuildContext context) {
    if(sc.patientSchedules == null){
      sc.selectedDate = appointmentDates![0];
      sc.loadGetHistory(patientId: patientId, appointmentId: appointmentId);
    }

    return Material(
      child: Stack(
        children: [
          CustomBackground(
            appBar: CustomAppBar(
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios)),
              title: "Service Report",
              actions: [
                IconButton(
                    onPressed: () {
                      // Share or export report functionality could go here
                    },
                    icon: Icon(Icons.share))
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GetBuilder<CompletedAppointmentDetailsController>(
                  builder: (v) {
                    return v.loadingServiceHistory
                        ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Patient Info Card
                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust width
                                      maxHeight: 400, // Adjust height to fit calendar
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TableCalendar(
                                        calendarBuilders: CalendarBuilders(
                                          selectedBuilder: (context,date,d1){
                                            return Container(
                                              margin: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${date.day}',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            );
                                          },
                                          defaultBuilder: (context, date, _) {
                                            bool isAppointmentDate = false;
                                            print(DateFormat("MMM dd").format(date));
                                            appointmentDates!.forEach((element) {
                                              if(DateFormat("MMM dd").format(element) == DateFormat("MMM dd").format(date)){
                                                isAppointmentDate = true;
                                              }
                                            });
                                            Color ?cellColor;
                                            if (isAppointmentDate && DateFormat("MMM dd").format(sc.selectedDate!) == DateFormat("MMM dd").format(date)) {
                                              cellColor = Colors.green;
                                            } else if (isAppointmentDate) {
                                              cellColor = AppColors.primaryColor;
                                            }

                                            return Container(
                                              margin: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: cellColor ?? Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${date.day}',
                                                style: TextStyle(color: isAppointmentDate?Colors.white:Colors.black),
                                              ),
                                            );
                                          },
                                        ),
                                        selectedDayPredicate: (v){
                                          return isSameDay(v,sc.selectedDate);
                                        },
                                        headerStyle: HeaderStyle(
                                          formatButtonVisible: false,
                                          titleCentered: true,
                                        ),
                                        onDaySelected: (v, d) {
                                          sc.selectedDate = v;
                                          sc.loadGetHistory(
                                              appointmentId: appointmentId, patientId: patientId);
                                          Get.back();
                                        },
                                        focusedDay: appointmentDates![0],
                                        firstDay: appointmentDates![0],
                                        lastDay: DateTime(2050),
                                        currentDay: sc.selectedDate,
                                        calendarStyle: CalendarStyle(
                                          outsideDaysVisible: false,
                                        ),
                                        /*selectedDayPredicate: (day) {
                                          return appointmentDates!.any((date) => isSameDay(date, day));
                                        },*/
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Appointment Date",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            DateFormat("MMMM dd, yyyy").format(sc.selectedDate!),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: AppColors.primaryColor,
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Vital Signs Section
                        _buildSectionHeader("Baseline Vital Signs"),
                        SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildVitalInfo(Icons.thermostat, "Temp", "${sc.temp.text}°F", Colors.orange),
                                _buildVitalInfo(Icons.favorite, "Pulse", "${sc.heartRate.text} bpm", Colors.red),
                                _buildVitalInfo(Icons.air, "Resp", "${sc.respiration.text}", Colors.blue),
                                _buildVitalInfo(Icons.speed, "BP", "${sc.bp.text}", Colors.green),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Blood Sugar Section
                        _buildSectionHeader("Blood Sugar"),
                        SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.bloodtype, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  "${sc.bloodSugarTEC.text} mg/dL",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Food and Nutrition Section
                        _buildSectionHeader("Food and Nutrition"),
                        SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMealRow("Breakfast", sc.filters.isNotEmpty ? sc.filters.first :
                                _formatTime(sc.patientSchedules?.patientBreakfasttime), sc.breakfastField.text),
                                Divider(),
                                _buildMealRow("Lunch", sc.lunchFilters.isNotEmpty ? sc.lunchFilters.first :
                                _formatTime(sc.patientSchedules?.patientLunchtime), sc.lunchField.text),
                                Divider(),
                                _buildMealRow("Snacks", sc.snacks.isNotEmpty ? sc.snacks.first :
                                _formatTime(sc.patientSchedules?.patientSnackstime), sc.snacksField.text),
                                Divider(),
                                _buildMealRow("Dinner", sc.dinner.isNotEmpty ? sc.dinner.first :
                                _formatTime(sc.patientSchedules?.patientDinnertime), sc.dinnerField.text),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Hydration Section
                        _buildSectionHeader("Hydration"),
                        SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.blue),
                                SizedBox(width: 10),
                                Text(
                                  "${sc.hydrationTEC.text}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Daily Care Activities Section
                        _buildSectionHeader("Daily Care Activities"),
                        SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildActivityRow("Oral Care", sc.selectedOralCareTimings.join(", ")),
                                Divider(),
                                _buildActivityRow("Bathing", sc.selectedBathingTimings.join(", ")),
                                Divider(),
                                _buildActivityRow("Dressing", sc.selectedDressingTimings.join(", ")),
                                Divider(),
                                _buildActivityRow("Walking", sc.selectedWalkingTimings.join(", ")),
                                Divider(),
                                _buildActivityRow("Toileting", sc.toileting.text),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Medication Section
                        _buildSectionHeader("Medication"),
                        SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time: ${sc.selectedMedication ?? "N/A"}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 12),
                                sc.selectedMedication != null
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: sc.meditationDetails
                                      .firstWhere((element) =>
                                  element.time == sc.selectedMedication!)
                                      .medicationDetails!
                                      .map((controller) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.medication, color: AppColors.primaryColor, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          controller.text.isEmpty ? "Not specified" : controller.text,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ))
                                      .toList(),
                                )
                                    : Text(
                                  "No medication recorded",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time: ${"Noon" ?? "N/A"}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 12),
                                sc.selectedMedication != null
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: sc.meditationDetails
                                      .firstWhere((element) =>
                                  element.time == "Noon")
                                      .medicationDetails!
                                      .map((controller) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.medication, color: AppColors.primaryColor, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          controller.text.isEmpty ? "Not specified" : controller.text,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ))
                                      .toList(),
                                )
                                    : Text(
                                  "No medication recorded",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time: ${"Evening" ?? "N/A"}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 12),
                                sc.selectedMedication != null
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: sc.meditationDetails
                                      .firstWhere((element) =>
                                  element.time == "Evening"!)
                                      .medicationDetails!
                                      .map((controller) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.medication, color: AppColors.primaryColor, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          controller.text.isEmpty ? "Not specified" : controller.text,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ))
                                      .toList(),
                                )
                                    : Text(
                                  "No medication recorded",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalInfo(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMealRow(String mealType, String? time, String details) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                time ?? "Not recorded",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            details.isEmpty ? "No details recorded" : details,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String activity, String timing) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            activity,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          Text(
            timing.isEmpty ? "Not recorded" : timing,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String? _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    try {
      final timeParts = timeString.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      return (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0') +
          '.' + minute + (hour < 12 ? ' AM' : ' PM');
    } catch (e) {
      return timeString;
    }
  }
}