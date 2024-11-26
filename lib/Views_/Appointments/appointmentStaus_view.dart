import 'package:animated_refresh/animated_refresh.dart';
import 'package:care2caretaker/Views_/HomeScreen/home-screen.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/Custom_AppoinMents.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:flutter/material.dart' hide RefreshIndicatorTriggerMode;
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
            tabs: [
              Tab(text: 'Approved'),
              Tab(text: 'Processing'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
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
                          itemCount: v.approvedList.length,
                          itemBuilder: (context, index) {
                            var data = v.approvedList[index];
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
                          itemCount: v.processingList.length,
                          itemBuilder: (context, index) {
                            var data = v.processingList[index];
                            String? path =
                                '${v.careTakersListResponse!.profilePath}';
                            String? url = '${data.patient!.profileImageUrl}';
                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => NewPatientHistory(
                                        appointmentId: data.id,
                                        patientId: data.patientId,
                                      ));
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
                          itemCount: v.rejectedList.length,
                          itemBuilder: (context, index) {
                            var data = v.rejectedList[index];
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
    );
  }
}
