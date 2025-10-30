import 'package:care2caretaker/Utils/screen_utils.dart';
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
  PatientrequestView({super.key,this.showBack = false});

  bool ?showBack;

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        leading: showBack!?IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ): SizedBox(),
        title: "Request From Patients",
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r),
        child: CustomPatientRequest(),
      ),
    );
  }
}

class CustomPatientRequest extends StatelessWidget {
  CustomPatientRequest({super.key});

  final PatientRequestController controller = Get.put(PatientRequestController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await controller.loadRequests(),
      child: GetBuilder<PatientRequestController>(builder: (v) {
        if (v.isLoading) return const ShimmerLoaderShimmer();

        if (v.requestList.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Text(
                  "No Requests Found",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ),
            ],
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: v.requestList.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            var res = v.requestList[index];
            var data = res.patient?.patientInfo;
            var schedule = res.patient?.patientSchedules;
            var path = v.careTakersListResponse?.profilePath ?? '';

            if (data == null) {
              return const Center(child: Text('No patient data available'));
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 0.8),
              ),
              child: Column(
                children: [
                  // Patient Info
                  carTakerList(
                    context,
                    controller,
                    index,
                    doctorName: '${data.firstName} ${data.lastName}',
                    doctorDesignation: "Patient",
                    doctorState: data.address,
                    imageUrl: '$path${res.patient!.profileImageUrl}',
                    age: data.age,
                    bmi: data.bmi,
                    sendTime: data.createdAt,
                    sendDate: data.createdAt,
                  ),

                  const Divider(thickness: 0.3),

                  // Footer button
                  InkWell(
                    onTap: () {
                      Get.to(() => Primaryinformationview(
                        bmi: data.bmi,
                        age: data.age,
                        toTime: res.appointmentStartTime,
                        dates: res.appointmentDates,
                        sex: data.sex,
                        sendDate: res.appointmentDate,
                        sendTime: res.appointmentEndTime,
                        firstName: data.firstName,
                        lastName: data.lastName,
                        nationality: data.address,
                        appointmentId: res.id,
                        patientId: res.patientId,
                        patientContactNumber: data.primaryContactNumber,
                        imgUrl: '$path${res.patient!.profileImageUrl}',
                        breakfast: schedule?.patientBreakfasttime,
                        dinner: schedule?.patientDinnertime,
                        snacks: schedule?.patientSnackstime,
                        lunch: schedule?.patientLunchtime,
                        BP: schedule?.patientBloodsugar,
                        schedule: schedule,
                      ));
                    },
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(14.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "View Request",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}


Widget carTakerList(
    BuildContext context,
    PatientRequestController controller,
    int index, {
      String? doctorName,
      String? doctorDesignation,
      String? doctorState,
      int? age,
      double? bmi,
      DateTime? sendTime,
      DateTime? sendDate,
      String? imageUrl,
    }) {
  final isiPad = isiPadLayout(context);

  return Padding(
    padding: EdgeInsets.all(12.r),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: isiPad ? 40.r : 30.r,
          backgroundImage: NetworkImage(imageUrl ?? ''),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      doctorName ?? '',
                      style: TextStyle(
                        fontSize: isiPad ? 18.sp : 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Image.asset(
                    "assets/images/verified_tick.png",
                    height: 16.h,
                  ),
                ],
              ),
              Text(
                doctorDesignation ?? '',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                doctorState ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.caretakersList[index].patient!.patientInfo!.sex == "male"
                  ? Icons.male
                  : Icons.female,
              size: 34.sp,
              color:
              controller.caretakersList[index].patient!.patientInfo!.sex == "male"
                  ? Colors.blueAccent
                  : Colors.pinkAccent,
            ),
          ],
        ),
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
