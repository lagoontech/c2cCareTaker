

import 'package:care2caretaker/Views_/Address_screen/Address_view.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/Custom_AppoinMents.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.cloud_download_sharp),
              color: AppColors.primaryColor,
            ),
            IconButton(
              onPressed: () {
                Get.to(() => const AddressView());
              },
              icon: Icon(Icons.share_rounded),
              color: AppColors.primaryColor,
            ),
          ],
          title: "E-Receipt",
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              AppointmentsContainer(
                imageUrl: 'assets/images/Rectangle 4482.png',
                appointmentDate: '23-08-2024',
                appointmentTime: '09-00AM',
                doctorName: 'HrBeena',
                doctorDesignation: 'Orthopedic',
                statusColor: AppColors.secondaryColor,
              ),
              kHeight15,
              CustomLabel(text: "Payment Summary"),
              kHeight15,
              paymentSummary(r1: "Date", r2: '23-08-24'),
              paymentSummary(r1: "Time", r2: '09:00Am - 10:00AM'),
              paymentSummary(r1: "Package", r2: 'Package'),
              paymentSummary(r1: "Duration", r2: '30 mins'),
              paymentSummary(r1: "Amount", r2: '\$80'),
              paymentSummary(r1: "Payment Method", r2: 'UPI'),
              paymentSummary(r1: "GST", r2: '\$1'),
            ],
          ),
        ));
  }

  Widget paymentSummary({required String r1, required String r2}) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 8.w, top: 8.h, bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              r1,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 20.w), // Space between the label and value
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              r2,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15.sp,
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
