import 'package:care2caretaker/Views_/HomeScreen/controller/home_controller.dart';
import 'package:care2caretaker/Utils/null_safe_utils.dart';
import 'package:care2caretaker/Views_/PatientRequest/controller/patient_request_controller.dart';
import 'package:care2caretaker/Views_/Profile/Controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/appBar.dart';
import '../../reuse_widgets/customLabel.dart';
import '../../reuse_widgets/empty_state_view.dart';
import '../../reuse_widgets/sizes.dart';
import '../PatientRequest/PatientRequest_view.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController hm = Get.put(HomeController());

  ProfileController hc = Get.put(ProfileController());
  PatientRequestController vc = Get.put(PatientRequestController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (v) {
      if (v.fetchLoading || v.profileList?.data == null) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: HomePageSkeleton(),
        );
      }

      final profileData = hc.profileList?.data;
      final caretakerInfo = profileData?.caretakerInfo;
      final profilePath = hc.profileList?.profilePath ?? '';
      final profileImage = profileData?.profileImage ?? '';
      final full = '$profilePath$profileImage';
      return Scaffold(
        appBar: HomeAppBar(
          username: NullSafe.orEmpty(caretakerInfo?.firstName),
          subtitle: 'How is your Health?',
          avatarUrl: full,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Seamless pattern bg1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome ",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black, // Default text color
                                ),
                              ),
                              TextSpan(
                                text: "CareTaker",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors
                                      .primaryColor, // CareTaker text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  kHeight10,
                  Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: new LinearGradient(
                            colors: [
                              Color(0xff52AAFC),
                              Color(0xff41A2FD),
                            ],
                            stops: [
                              0.9,
                              1.6
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            tileMode: TileMode.repeated)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.w, right: 4.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Your well-being is our priority. Trust us to provide the support you deserve",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Image.asset(
                                fit: BoxFit.cover,
                                "assets/images/female-nurse-hospital 1.png",
                              ),
                            )),
                      ],
                    ),
                  ),
                  kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomLabel(
                          text: "Upcoming Appointments",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => PatientrequestView(showBack: true));
                        },
                        child: CustomLabel(
                          text: "See all",
                          fontSize: 13.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  GetBuilder<PatientRequestController>(builder: (v) {
                    return v.processingList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: v.processingList.length > 4
                                ? 4
                                : v.processingList.length,
                            itemBuilder: (BuildContext context, index) {
                              var res = v.processingList[index];
                              var path =
                                  v.careTakersListResponse?.profilePath ?? '';
                              final patientInfo = res.patient?.patientInfo;
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.h),
                                child: CustomCareTakers(
                                  name: NullSafe.displayName(
                                      patientInfo?.firstName,
                                      patientInfo?.lastName),
                                  age: patientInfo?.age,
                                  appointmentDate: res.appointmentDate,
                                  appointmentDates: res.appointmentDates,
                                  startTime: res.appointmentStartTime,
                                  endTime: res.appointmentEndTime,
                                  gender: patientInfo?.sex,
                                  //initial: 2,
                                  imageUrl:
                                      '$path${res.patient?.profileImageUrl ?? ''}',
                                ),
                              );
                            })
                        : EmptyStateView(
                            icon: Icons.calendar_month_rounded,
                            title: 'No upcoming appointments',
                            subtitle:
                                'Scheduled visits will appear here once assigned.',
                            minHeight:
                                MediaQuery.of(context).size.height * 0.22,
                          );
                  }),
                  /*     kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomLabel(
                          text: "Upcomming Appointments",
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomLabel(
                        text: "See all",
                        fontSize: 15.sp,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  kHeight10,
                  AppointmentsContainer(
                    appointmentDate: "Sun Aug 08",
                    appointmentTime: '10:00-11:00 AM',
                    doctorDesignation: "Ortho",
                    doctorName: "Sheeba",
                    imageUrl: 'assets/images/profile.jpg',
                  ),*/
                  kHeight30,
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// Custom Stateless Widget
class CustomCareTakers extends StatelessWidget {
  final String? name;
  final int? age;
  final String? imageUrl;
  final double initial;
  String? gender;

  DateTime? appointmentDate;
  List<DateTime>? appointmentDates;
  String? startTime;
  String? endTime;
  double? height;
  final VoidCallback? onPressed;

  // Constructor with named parameters
  CustomCareTakers(
      {this.name,
      this.imageUrl,
      this.age,
      this.gender,
      this.height,
      this.initial = 3.0,
      this.onPressed,
      this.startTime,
      this.endTime,
      this.appointmentDate,
      this.appointmentDates});

  @override
  Widget build(BuildContext context) {
    // Convert startTime and endTime from String to DateTime
    DateTime? startDateTime;
    DateTime? endDateTime;

    if (startTime != null) {
      // Assuming startTime is in "HH:mm:ss" format
      final List<String> startParts = startTime!.split(':');
      startDateTime =
          DateTime(0, 1, 1, int.parse(startParts[0]), int.parse(startParts[1]));
    }

    if (endTime != null) {
      // Assuming endTime is in "HH:mm:ss" format
      final List<String> endParts = endTime!.split(':');
      endDateTime =
          DateTime(0, 1, 1, int.parse(endParts[0]), int.parse(endParts[1]));
    }
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
      padding: EdgeInsets.all(6.r),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              fit: BoxFit.cover,
              imageUrl ?? '',
              errorBuilder: (b, c, s) {
                return Icon(
                  Icons.person,
                  size: 22.sp,
                  color: Colors.white,
                );
              },
            ),
          ),
          kWidth10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Age : ${age ?? ''}  |  Gender : ${gender?.capitalize ?? ''}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11.sp,
                  ),
                ),
                Row(
                  children: [
                    if (NullSafe.hasDates(appointmentDates))
                      Text(
                        DateFormat("MMM dd")
                            .format(NullSafe.firstDate(appointmentDates)!),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (NullSafe.hasDates(appointmentDates) &&
                        appointmentDates!.length > 1)
                      Text(
                        " To ${DateFormat("MMM dd").format(NullSafe.lastDate(appointmentDates)!)}",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                Text(
                  "${startTime != null ? DateFormat('h:mm a').format(startDateTime!) : ''} To ${endTime != null ? DateFormat('h:mm a').format(endDateTime!) : ''}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 15),
            _buildCardSkeleton(context),
            SizedBox(height: 10),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 10),
            Expanded(child: _buildListSkeleton()),
            SizedBox(height: 10),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 10),
            _buildAppointmentSkeleton(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 200,
            height: 20,
            color: Colors.white,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 50,
            height: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCardSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildListSkeleton() {
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 150,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }
}
