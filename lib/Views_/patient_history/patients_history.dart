import 'package:animated_refresh/animated_refresh.dart';
import 'package:care2caretaker/Views_/Receipt/receipt_view.dart';
import 'package:care2caretaker/Views_/schedule/schedule_view.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide  DateUtils;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../Utils/date_utils.dart';
import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/custom_textfield.dart';
import '../PatientRequest/controller/patient_request_controller.dart';

class PatientsHistory extends StatefulWidget {
  const PatientsHistory({super.key});

  @override
  State<PatientsHistory> createState() => _PatientsHistoryState();
}

class _PatientsHistoryState extends State<PatientsHistory> {
  final PatientRequestController controller =
      Get.put(PatientRequestController());

  void showPatientDetailsDialog(
    BuildContext context,
    String name,
    String date,
    String time,
    String imgurl,
    String status,
    String? breakfast,
    String? patientBreakfasttime,
    String? patientBreakfasttimeDetails,
    String? patientLunchtime,
    String? patientLunchtimeDetails,
    String? patientSnackstime,
    String? patientSnackstimeDetails,
    String? patientDinnertime,
    String? patientDinnertimeDetails,
    String? patientMedications,
    String? patientMedicationsDetails,
    String? patientHydration,
    String? patientOralcare,
    String? patientBathing,
    String? patientDressing,
    String? patientToileting,
    String? patientWalkingtime,
    String? patientVitalsigns,
    String? patientBloodsugar,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Service History")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Patient : ${name}",
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text("Date: $date"),
                Text("Time: $time"),
                Text(
                    "Status: ${status[0].toUpperCase()}${status.substring(1)}"),
                kHeight5,
                Text(
                  "Service Given",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                kHeight5,
                Text("Breakfast: $breakfast"),
                if (patientBreakfasttime != null)
                  Text("Breakfast Time: $patientBreakfasttime"),
                if (patientBreakfasttimeDetails != null)
                  Text("Breakfast Details: $patientBreakfasttimeDetails"),
                if (patientLunchtime != null)
                  Text("Lunch Time: $patientLunchtime"),
                if (patientLunchtimeDetails != null)
                  Text("Lunch Details: $patientLunchtimeDetails"),
                if (patientSnackstime != null)
                  Text("Snacks Time: $patientSnackstime"),
                if (patientSnackstimeDetails != null)
                  Text("Snacks Details: $patientSnackstimeDetails"),
                if (patientDinnertime != null)
                  Text("Dinner Time: $patientDinnertime"),
                if (patientDinnertimeDetails != null)
                  Text("Dinner Details: $patientDinnertimeDetails"),
                if (patientMedications != null)
                  Text("Medications: $patientMedications"),
                if (patientMedicationsDetails != null)
                  Text("Medications Details: $patientMedicationsDetails"),
                if (patientHydration != null)
                  Text("Hydration: $patientHydration"),
                if (patientOralcare != null)
                  Text("Oral Care: $patientOralcare"),
                if (patientBathing != null) Text("Bathing: $patientBathing"),
                if (patientDressing != null) Text("Dressing: $patientDressing"),
                if (patientToileting != null)
                  Text("Toileting: $patientToileting"),
                if (patientWalkingtime != null)
                  Text("Walking Time: $patientWalkingtime"),
                if (patientVitalsigns != null)
                  Text("Vital Signs: $patientVitalsigns"),
                if (patientBloodsugar != null)
                  Text("Blood Sugar: $patientBloodsugar"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    controller.loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: "Patient History",
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month))
        ],
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 2.h,
                  vertical: 2.h),
              child: Row(
                children: [

                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: kToolbarHeight * 0.9,
                      child: customTextField(
                        context,
                        onChanged: (v){
                          controller.searchAppointments(completedOnly: true);
                        },
                        hint: "Search appointments",
                        controller: controller.searchTEC,
                        borderColor: AppColors.primaryColor,
                        labelText: "",
                        prefix: Icon(Icons.search),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Container(
                        height: kToolbarHeight * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(Icons.calendar_month),

                            SizedBox(width: 4.w),

                            GetBuilder<PatientRequestController>(
                                builder: (vc) {
                                  return controller.selectedDate!=null
                                      ? Text(controller.displayDate.toString(),style: TextStyle(
                                      fontSize: 12.sp
                                  ),)
                                      : Center(child: Text("Select a date",style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "verdana_regular"
                                  ),));

                                }
                            ),

                            SizedBox(width: 2.w),

                            GetBuilder<PatientRequestController>(
                                builder: (vc) {
                                  return controller.selectedDate!=null
                                      ? GestureDetector(
                                      onTap: (){
                                        controller.selectedDate = null;
                                        controller.displayDate = null;
                                        controller.update();
                                        controller.searchAppointments(completedOnly: true);
                                      },
                                      child: Icon(Icons.cancel_outlined)
                                  )
                                      : SizedBox();
                                }
                            )

                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
            kHeight10,
            GetBuilder<PatientRequestController>(builder: (v) {
              return AnimatedRefresh(
                  backgroundColor: Colors.transparent,
                  onRefresh: _refreshData,
                  swipeChild: Icon(Icons.arrow_upward_rounded),
                  refreshChild: Lottie.asset(
                    "assets/lottie/lottieflow-loading-08-15ADD2-easey.json",
                    fit: BoxFit.fill,
                    width: 50,
                    height: 50,
                  ),
                  child: controller.completedList.isEmpty
                      ? SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child:
                                Center(child: Text('No History Available')),
                          ),
                        )
                      : ListView.builder(
                          itemCount: v.searchedCompletedList.isEmpty && v.searchTEC.text.isEmpty && v.displayDate==null
                              ? v.completedList.length
                              : v.searchedCompletedList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // Prevent scrolling in nested ListView
                          itemBuilder: (context, index) {
                            var data;
                            if(v.searchedCompletedList.isNotEmpty){
                              data = v.searchedCompletedList[index];
                            }else{
                              data = v.completedList[index];
                            }
                            var path = v.careTakersListResponse!.profilePath;
                            var url = data.patient!.profileImageUrl;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: WaitingPatients(
                                patientId: data.id,
                                appoinId: data.patientId,
                                showIcon: false,
                                status: data.serviceStatus,
                                name: data.patient!.patientInfo!.firstName!,
                                date: DateFormat('dd MMM yyyy')
                                    .format(data.appointmentDate!),
                                imgurl: '${path}${url}',
                                time:
                                    '${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${data.appointmentStartTime!}'))} - ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${data.appointmentEndTime!}'))}',
                                onTapDialog: () async {
                                  try {
                                    await controller.loadGetHistory(
                                      patientId: data.patientId,
                                      appointmentId: data.id,
                                    );
                                    if (controller.serviceHistory?.data !=
                                        null) {
                                      final patientInfo = controller
                                          .serviceHistory!
                                          .data!
                                          .patient!
                                          .patientInfo;
                                      final detailsdata = controller
                                          .serviceHistory!
                                          .data; // Accessing detailed data

                                      // Extracting detailed properties
                                      String? breakfast = detailsdata!
                                          .patientBreakfasttime; // Ensure this is nullable

                                      String? patientBreakfasttime =
                                          detailsdata.patientBreakfasttime;
                                      String? patientBreakfasttimeDetails =
                                          detailsdata
                                              .patientBreakfasttimeDetails;
                                      String? patientLunchtime =
                                          detailsdata.patientLunchtime;
                                      String? patientLunchtimeDetails =
                                          detailsdata.patientLunchtimeDetails;
                                      String? patientSnackstime =
                                          detailsdata.patientSnackstime;
                                      String? patientSnackstimeDetails =
                                          detailsdata.patientSnackstimeDetails;
                                      String? patientDinnertime =
                                          detailsdata.patientDinnertime;
                                      String? patientDinnertimeDetails =
                                          detailsdata.patientDinnertimeDetails;
                                      String? patientMedications =
                                          detailsdata.patientMedications;
                                      String? patientMedicationsDetails =
                                          detailsdata.patientMedicationsDetails;
                                      String? patientHydration =
                                          detailsdata.patientHydration;
                                      String? patientOralcare =
                                          detailsdata.patientOralcare;
                                      String? patientBathing =
                                          detailsdata.patientBathing;
                                      String? patientDressing =
                                          detailsdata.patientDressing;
                                      String? patientToileting =
                                          detailsdata.patientToileting;
                                      String? patientWalkingtime =
                                          detailsdata.patientWalkingtime;
                                      String? patientVitalsigns =
                                          detailsdata.patientVitalsigns;
                                      String? patientBloodsugar =
                                          detailsdata.patientBloodsugar;

                                      // Calling the dlialog function with all parameters
                                      showPatientDetailsDialog(
                                        context,
                                        patientInfo!.firstName!,
                                        DateFormat('dd MMM yyyy').format(
                                            controller.serviceHistory!.data!
                                                .appointment!.appointmentDate!),
                                        '${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${data.appointmentStartTime!}'))} - ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${data.appointmentEndTime!}'))}',
                                        '${path}${url}',
                                        data.serviceStatus ?? '',
                                        breakfast,
                                        // Ensure this is provided
                                        patientBreakfasttime,
                                        patientBreakfasttimeDetails,
                                        patientLunchtime,
                                        patientLunchtimeDetails,
                                        patientSnackstime,
                                        patientSnackstimeDetails,
                                        patientDinnertime,
                                        patientDinnertimeDetails,
                                        patientMedications,
                                        patientMedicationsDetails,
                                        patientHydration,
                                        patientOralcare,
                                        patientBathing,
                                        patientDressing,
                                        patientToileting,
                                        patientWalkingtime,
                                        patientVitalsigns,
                                        patientBloodsugar,
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar('Error',
                                        'Failed to load patient history',
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                              ),
                            );
                          },
                        ));
            }),
            kHeight10,
          ],
        ).paddingSymmetric(horizontal: 10.w),
      ),
    );
  }

  //
  Future<void> _selectDate(BuildContext context) async {

    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
                primary: Colors.purple,
                onPrimary: Colors.white,
                onSurface: Colors.black
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if(date!=null){
      controller.selectedDate = date;
      controller.displayDate = DateUtils().dateOnlyFormat(date);
      controller.update();
      controller.searchAppointments(completedOnly: true);
    }
  }

}
