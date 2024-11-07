import 'package:care2caretaker/Views_/Profile/Controller/profileController.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../primaryInformation/primaryinformationView.dart';
import 'controller/patient_request_controller.dart';

class PatientrequestView extends StatelessWidget {
  PatientrequestView({super.key});

  final PatientRequestController controller =
      Get.put(PatientRequestController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: "Request From Patients",
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r),
        child: CustomPatientRequest(controller: controller),
      ),
    );
  }
}

class CustomPatientRequest extends StatelessWidget {
  CustomPatientRequest({super.key, required this.controller});

  final PatientRequestController controller;
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadRequests();
      },
      child: GetBuilder<PatientRequestController>(builder: (v) {
        if (v.isLoading) {
          return ShimmerLoaderShimmer();
        }

        if (v.requestList.isEmpty) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Center(child: Text("No Requests Found")),
            ],
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: v.requestList.length,
          itemBuilder: (BuildContext context, int index) {
            var res = v.requestList[index];
            var path = v.careTakersListResponse!.profilePath;
            var data = res.patient!.patientInfo;
            var schedule = res.patient!.patientSchedules;

            if (data == null) {
              return const Center(child: Text('No patient data available'));
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => Primaryinformationview(
                              bmi: data.bmi,
                              age: data.age,
                              toTime: res.appointmentStartTime,
                              sex: data.sex,
                              sendDate: res.appointmentDate,
                              sendTime: res.appointmentEndTime,
                              firstName: data.firstName,
                              lastName: data.lastName,
                              nationality: data.nationality,
                              appointmentId: res.id,
                              patientId: res.patientId,
                              patientContactNumber: data.primaryContactNumber,
                              imgUrl: '${path}${res.patient!.profileImageUrl}',
                              breakfast: schedule!.patientBreakfasttime,
                              dinner: schedule.patientDinnertime,
                              snacks: schedule.patientSnackstime,
                              lunch: schedule.patientLunchtime,
                              BP: schedule.patientBloodsugar,
                            ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "View Request",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child:
                            GetBuilder<PatientRequestController>(builder: (v) {
                          return carTakerList(
                            context,
                            controller,
                            index,
                            doctorState: data.nationality,
                            sendDate: data.createdAt,
                            doctorDesignation: "Patient",
                            bmi: data.bmi,
                            sendTime: data.createdAt,
                            imageUrl: '${path}${res.patient!.profileImageUrl}',
                            age: data.age,
                            doctorName: '${data.firstName} ${data.lastName}',
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

Widget carTakerList(
    BuildContext context, PatientRequestController controllerd, int? index,
    {String? name,
    String? doctorName,
    String? doctorDesignation,
    String? doctorState,
    int? age,
    double? bmi,
    DateTime? sendTime,
    DateTime? sendDate,
    String? imageUrl}) {
  return Container(
    padding: EdgeInsets.all(10.r),
    height: MediaQuery.of(context).size.height * 0.14,
    // Adjusted height
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: Colors.white,
      ),
    ),
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: NetworkImage(imageUrl ?? ''),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          doctorName ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 5.w),
                        // Add spacing between text and icon
                        Image.asset(
                          "assets/images/verified_tick.png",
                          fit: BoxFit.cover,
                          height: 17.h,
                        ),
                      ],
                    ),
                    Text(
                      doctorDesignation ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      doctorState ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    controllerd.caretakersList[index!].patient!.patientInfo!
                                .sex ==
                            "male"
                        ? Icons.male
                        : Icons.female,
                    // Conditional icon based on gender
                    size: 33.sp,
                    color: controllerd.caretakersList[index].patient!
                                .patientInfo!.sex ==
                            "male"
                        ? Colors.blueAccent
                        : Colors
                            .pinkAccent, // Conditional color based on gender
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(
          thickness: 0.2,
        ),
        /* Container(
          padding: EdgeInsets.zero,
          height: MediaQuery.of(context).size.height * 0.09, // Adjusted height
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          IconlyBold.user_2, // Icon for Age
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w), // Spacing between icon and text
                        Text(
                          "Age: $age", // Replace with actual age variable
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    kHeight10,
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center, // Icon for BMI
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 5.w), // Spacing between icon and text
                        Text(
                          "BMI: $bmi", // Replace with actual BMI variable
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right Side: Requested Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          IconlyBold.calendar, // Icon for Date
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 5.w), // Spacing between icon and text
                        Text(
                          "${DateFormat('yyyy-MM-dd').format(sendDate!)}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h), // Spacing between date and time
                    Row(
                      children: [
                        Icon(
                          IconlyBold.time_circle, // Icon for Requested Time
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 5.w), // Spacing between icon and text
                        Text(
                          "${DateFormat('hh:mm a').format(sendTime!)}",
                          // Replace with actual time variable
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )*/
      ],
    ),
  );
}

Widget Circleso(BuildContext context, {IconData? icon, String? name}) {
  return Column(
    children: [
      CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.primaryColor,
        child: Icon(icon, color: Colors.white),
      ),
      SizedBox(height: 6.h),
      Text(
        name ?? '',
        style: TextStyle(
          color: Colors.black,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      )
    ],
  );
}

class ShimmerLoaderShimmer extends StatelessWidget {
  const ShimmerLoaderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 150.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 150.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
