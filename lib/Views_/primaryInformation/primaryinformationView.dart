import 'package:care2caretaker/Views_/HomeView/Controller/bottomNav_controller.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customButton.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/customToast.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/sizes.dart';
import '../PatientRequest/controller/patient_request_controller.dart';

class Primaryinformationview extends StatefulWidget {
  String? firstName;
  String? lastName;
  String? sex;
  int? age;
  String? nationality;
  String? imgUrl;
  int? appointmentId;
  int? patientId;
  String? breakfast;
  String? lunch;
  String? dinner;
  String? snacks;
  String? BP;
  String? patientContactNumber;
  DateTime? sendDate;
  String? sendTime;
  String? toTime;
  double? bmi;

  Primaryinformationview(
      {super.key,
      this.firstName,
      this.lastName,
      this.sex,
      this.bmi,
      this.age,
      this.imgUrl,
      this.patientId,
      this.breakfast,
      this.lunch,
      this.dinner,
      this.snacks,
      this.appointmentId,
      this.BP,
      this.sendTime,
      this.toTime,
      this.sendDate,
      this.patientContactNumber,
      this.nationality});

  @override
  State<Primaryinformationview> createState() => _PrimaryinformationviewState();
}

class _PrimaryinformationviewState extends State<Primaryinformationview> {
  String? selectedValue;
  final BottomNavController bn = Get.put(BottomNavController());
  final PatientRequestController controller =
      Get.put(PatientRequestController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        bottomNavBar: GetBuilder<PatientRequestController>(builder: (request) {
          return Container(
            height: 80.h, // Adjust height as needed
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    isLoading: request.isRejecting,
                    text: "Reject",
                    color: Colors.red.withOpacity(0.9),
                    onPressed: () {
                      request.isRejecting = true;
                      request.update();
                      request.rejectRequestApi(
                        appointmentId: widget.appointmentId,
                        patientId: widget.patientId,
                      );
                      request.isRejecting = false;
                      request.update();
                      debugPrint('Request Rejected');
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    isLoading: request.isAccepting,
                    text: "Accept",
                    color: Colors.green.withOpacity(0.9),
                    onPressed: () {
                      request.isAccepting = true;
                      request.update();
                      request.acceptRequestApi(
                        appointmentId: widget.appointmentId,
                        patientId: widget.patientId,
                      );
                      request.isAccepting = false;
                      request.update();
                      debugPrint('Request Rejected');
                    },
                  ),
                ),
              ],
            ),
          );
        }),
        appBar: CustomAppBar(
          title: "Primary Information",
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                carTakerList(context,
                    doctorName: '${widget.firstName}${widget.lastName}',
                    doctorState: widget.nationality,
                    //genderIcon: widget.sex,
                    sendTime: widget.toTime,
                    sendDate: widget.sendDate,
                    age: widget.age,
                    bmi: widget.bmi,
                    toTime: widget.sendTime,
                    imageUrl: widget.imgUrl),
                kHeight15,
                InkWell(
                  onTap: () {
                    controller.launchDialer(widget.patientContactNumber!);
                  },
                  child: Container(
                    height: 35.h,
                    width: 150.h,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(23.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.r, vertical: 5.r),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_outlined,
                              size: 15.sp,
                            ),
                          ),
                          kWidth5,
                          Text(
                            "Contact Patient",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                kHeight15,
                CustomLabel(text: "About"),
                kHeight5,
                ReadMoreText(
                    style: TextStyle(),
                    trimLines: 2,
                    lessStyle: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    moreStyle: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    trimMode: TrimMode.Line,
                    "It seems like you've entered readmore text nwithout completing the request. Could you please provide more details or clarify your query so I can assist you better?"),
                Divider(
                  thickness: 0.2,
                ),
                DocsCustom(
                  radiusSize: 26,
                  heading: "Experience Certificates",
                  message: "Add your career info",
                  icons: EneftyIcons.hospital_bold,
                  iconColor: Colors.orange,
                ),
                Divider(
                  thickness: 0.2,
                ),
                kHeight5,
                CustomLabel(text: "Personal Details"),
                kHeight10,
                Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        savedDetails(context,
                            details: "BreakFast", timing: widget.breakfast),
                        kWidth5,
                        savedDetails(context,
                            details: "lunch", timing: widget.lunch),
                        kWidth5,
                        savedDetails(context,
                            details: "Snacks", timing: widget.snacks),
                        kWidth5,
                        savedDetails(context,
                            details: "Dinner", timing: widget.dinner),
                      ],
                    ),
                  ),
                ),
                kHeight5,
                CustomLabel(text: "Vital Signs"),
                kHeight10,
                Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        savedDetails(context,
                            details: "Temperature", timing: "98.6\u2109F"),
                        kWidth5,
                        savedDetails(context, details: "Pulse", timing: "80"),
                        kWidth5,
                        savedDetails(context,
                            details: "Respiration", timing: "12-14"),
                        kWidth5,
                      ],
                    ),
                  ),
                ),
                kHeight5,
                CustomLabel(text: "Blood Sugar Level"),
                kHeight10,
                Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        savedDetails(context, details: "BP", timing: widget.BP),
                        kWidth5,
                        /* savedDetails(context, details: "Noon", timing: "70mg"),
                        kWidth5,
                        savedDetails(context,
                            details: "Evening", timing: "70mg"),
                        kWidth5,*/
                      ],
                    ),
                  ),
                ),
                kHeight10,
              ],
            ),
          ),
        ));
  }

  Widget savedDetails(BuildContext context, {String? details, String? timing}) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.all(8.r),
      decoration: const BoxDecoration(
        color: Color(0xffF5F5F5),
      ),
      child: Row(
        children: [
          Text(details ?? ''),
          kWidth5,
          const Text(':'),
          kWidth5,
          Text(timing ?? '')
        ],
      ),
    );
  }

  Widget carTakerList(BuildContext context,
      {String? name,
      String? doctorName,
      String? doctorDesignation,
      String? doctorState,
      IconData? genderIcon,
      int? age,
      DateTime? sendDate,
      String? sendTime,
      String? toTime,
      double? bmi,
      String? imageUrl}) {
    return Container(
      padding: EdgeInsets.all(10.r),
      height: MediaQuery.of(context).size.height * 0.24,
      // Adjusted height
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
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
                      /*  Text(
                      doctorDesignation ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),*/
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    genderIcon,
                    size: 33.sp,
                    color: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 0.2,
          ),
          Container(
            padding: EdgeInsets.zero,
            height:
                MediaQuery.of(context).size.height * 0.09, // Adjusted height
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
                            sendTime != null
                                ? "${DateFormat('hh:mm a').format(DateTime.parse('${DateFormat('yyyy-MM-dd').format(sendDate)} $sendTime'))}"
                                : 'Invalid Time',
                            // Replace with actual time variable
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text("-"), SizedBox(width: 2.w),
                          Text(
                            toTime != null
                                ? "${DateFormat('hh:mm a').format(DateTime.parse('${DateFormat('yyyy-MM-dd').format(sendDate)} $toTime'))}"
                                : 'Invalid Time',
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
          )
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
}

class DocsCustom extends StatelessWidget {
  final String? heading;
  final String? message;
  final IconData? icons;
  final Color? circleColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final double? radiusSize;

  DocsCustom({
    super.key,
    this.heading,
    this.message,
    this.icons,
    this.onTap,
    this.circleColor,
    this.iconColor,
    this.radiusSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // Ensures the Row shrinks to fit its children
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: circleColor ?? Colors.grey.withOpacity(0.1),
              radius: radiusSize ?? 22,
              child: Icon(
                icons,
                color: iconColor ?? Colors.black,
              ),
            ),
          ),
          kWidth10,
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    heading ?? "Alis Dia",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    message ?? "sujnc901@gmail.com",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
              ))
        ],
      ),
    );
  }
}
