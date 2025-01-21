import 'package:animated_refresh/animated_refresh.dart';
import 'package:care2caretaker/Views_/HomeScreen/home-screen.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/Custom_AppoinMents.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:flutter/material.dart' hide RefreshIndicatorTriggerMode , DateUtils;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/date_utils.dart';
import '../../reuse_widgets/custom_textfield.dart';
import '../PatientRequest/controller/patient_request_controller.dart';
import '../patient_history/newPattientHistory.dart';

class AppointmentStatusView extends StatelessWidget {
  AppointmentStatusView({super.key});

  final PatientRequestController controller =
      Get.put(PatientRequestController());

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    controller.loadRequests();
  }

  Future<void> _refreshReject() async {
    await Future.delayed(const Duration(seconds: 1));
    controller.loadRejectList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: CustomBackground(
        appBar: CustomAppBar(
          title: "Appointments",
          bottom: TabBar(
            onTap: (v){
              controller.currentTab = v;
              controller.searchAppointments();
            },
            tabs: [
              Tab(text: 'Approved'),
              Tab(text: 'Processing'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        child: Column(
          children: [

            SizedBox(height: 8.h),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.h,
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
                          controller.searchAppointments();
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
                                        controller.searchAppointments();
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

            Expanded(
              child: TabBarView(
                children: [
                  // Approved Tab
                  GetBuilder<PatientRequestController>(
                    builder: (v) {
                      return AnimatedRefresh(
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        backgroundColor: AppColors.secondaryColor,
                        onRefresh: _refreshData,
                        swipeChild: Icon(Icons.accessibility),
                        refreshChild: Lottie.asset(
                          "assets/lottie/lottieflow-loading-08-15ADD2-easey.json",
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                        child: v.approvedList.isEmpty
                            ? SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child:
                                      Center(child: Text('No approved appointments')),
                                ),
                              )
                            : ListView.builder(
                                itemCount: v.searchedApprovedList.isEmpty && v.displayDate == null && v.searchTEC.text.isEmpty
                                    ? v.approvedList.length
                                    : v.searchedApprovedList.length,
                                itemBuilder: (context, index) {
                                  var data;
                                  if(v.searchedApprovedList.isNotEmpty){
                                    data = v.searchedApprovedList[index];
                                  }else{
                                    data = v.approvedList[index];
                                  }
                                  String? path =
                                      '${v.careTakersListResponse!.profilePath}';
                                  String? url = '${data.patient!.profileImageUrl}';
                                  return Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: CustomCareTakers(
                                      name: data.patient!.patientInfo!.firstName,
                                      gender: data.patient!.patientInfo!.sex,
                                      age: data.patient!.patientInfo!.age,
                                      imageUrl: "${path}${url}",
                                      appointmentDate: data.appointmentDate,
                                      startTime: data.appointmentStartTime,
                                      endTime: data.appointmentEndTime,
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                  // Processing Tab
                  GetBuilder<PatientRequestController>(
                    builder: (v) {
                      return AnimatedRefresh(
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        backgroundColor: AppColors.secondaryColor,
                        onRefresh: _refreshData,
                        swipeChild: Icon(Icons.accessibility),
                        refreshChild: Lottie.asset(
                          "assets/lottie/lottieflow-loading-08-15ADD2-easey.json",
                          fit: BoxFit.fill,
                          width: 30,
                          height: 30,
                        ),
                        child: v.processingList.isEmpty
                            ? SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child: Center(
                                      child: Text('No processing appointments')),
                                ),
                              )
                            : ListView.builder(
                                itemCount: v.searchedProcessingList.isEmpty && v.displayDate == null && v.searchTEC.text.isEmpty
                                    ? v.processingList.length
                                    : v.searchedProcessingList.length,
                                itemBuilder: (context, index) {
                                  var data;
                                  if(v.searchedProcessingList.isNotEmpty){
                                    data = v.searchedProcessingList[index];
                                  }else{
                                    data = v.processingList[index];
                                  }
                                  String? path =
                                      '${v.careTakersListResponse!.profilePath}';
                                  String? url = '${data.patient!.profileImageUrl}';
                                  return Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: InkWell(
                                      onTap: () async {
                                        var result = await Get.to(() => NewPatientHistory(
                                              appointmentId: data.id,
                                              patientId: data.patientId,
                                            ));
                                        if(result!=null && result==1){
                                          v.loadRequests();
                                        }
                                      },
                                      child: CustomCareTakers(
                                        name: data.patient!.patientInfo!.firstName,
                                        gender: data.patient!.patientInfo!.sex,
                                        age: data.patient!.patientInfo!.age,
                                        imageUrl: "${path}${url}",
                                        appointmentDate: data.appointmentDate,
                                        startTime: data.appointmentStartTime,
                                        endTime: data.appointmentEndTime,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                  // Rejected Tab
                  GetBuilder<PatientRequestController>(
                    builder: (v) {
                      return AnimatedRefresh(
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        backgroundColor: AppColors.secondaryColor,
                        onRefresh: _refreshReject,
                        swipeChild: Icon(Icons.accessibility),
                        refreshChild: Lottie.asset(
                          "assets/lottie/lottieflow-loading-08-15ADD2-easey.json",
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                        child: v.rejectedList.isEmpty
                            ? SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child:
                                      Center(child: Text('No rejected appointments')),
                                ),
                              )
                            : ListView.builder(
                                itemCount: v.searchedRejectedList.isEmpty && v.displayDate == null && v.searchTEC.text.isEmpty
                                    ? v.rejectedList.length
                                    : v.searchedRejectedList.length,
                                itemBuilder: (context, index) {
                                  var data;
                                  if(v.searchedRejectedList.isNotEmpty){
                                    data = v.searchedRejectedList[index];
                                  } else{
                                    data = v.rejectedList[index];
                                  }
                                  String? path = '${v.careTakersListResponse!.profilePath}';
                                  String? url = '${data.patient!.profileImageUrl}';
                                  return Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: CustomCareTakers(
                                      name: data.patient!.patientInfo!.firstName,
                                      gender: data.patient!.patientInfo!.sex,
                                      age: data.patient!.patientInfo!.age,
                                      imageUrl: "${path}${url}",
                                      appointmentDate: data.appointmentDate,
                                      startTime: data.appointmentStartTime,
                                      endTime: data.appointmentEndTime,
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
      controller.searchAppointments();
    }

  }
}
