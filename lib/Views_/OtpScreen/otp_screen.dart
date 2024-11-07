import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/customButton.dart';
import 'Controller/otp_controller.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  OtpScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpController vc = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // added padding for responsiveness
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/svg/logo.svg",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
                SizedBox(height: 20.h),
                AutoSizeText(
                  "Enter your 4 Digits otp",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20.h),
                Text(
                  "We will send you a verification code",
                  textAlign: TextAlign.center,
                  maxLines: null,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: PinCodeTextField(
                    readOnly: true,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      inactiveColor: Colors.grey.shade600,
                      inactiveFillColor: Colors.white,
                      borderWidth: 0.sp,
                      errorBorderColor: Colors.red,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: 2.w),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 40.h,
                      fieldWidth: 45.w,
                      activeFillColor: Colors.grey.shade200,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.white,
                    enableActiveFill: true,
                    controller: vc.otpTEC,
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Resend code",
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                ),
                SizedBox(height: 40.h),
                GetBuilder<OtpController>(builder: (b) {
                  return CustomButton(
                    isLoading: b.isLoading,
                    width: MediaQuery.of(context).size.width * 0.8,
                    text: "Continue",
                    onPressed: b.isLoading
                        ? null
                        : () async {
                      b.checkOtp(widget.phone);
                    },
                  );
                }),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(top: 16.h), // additional padding for spacing
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: NumericKeyboard(
                      onKeyboardTap: (val) {
                        if (val == 99) {
                          if (vc.otpTEC.text.isEmpty) return;
                          vc.otpTEC.text = vc.otpTEC.text.substring(0, vc.otpTEC.text.length - 1);
                        } else {
                          vc.otpTEC.text += val.toString();
                          debugPrint(vc.otpTEC.text);
                        }
                      },
                      textStyle: TextStyle(fontSize: 22.sp, color: Colors.black, fontWeight: FontWeight.bold),
                      rightButtonFn: () {
                        if (vc.otpTEC.text.isNotEmpty) {
                          vc.otpTEC.text = vc.otpTEC.text.substring(0, vc.otpTEC.text.length - 1);
                          vc.update();
                        }
                      },
                      rightButtonLongPressFn: () {
                        vc.otpTEC.clear();
                        vc.update();
                      },
                      rightIcon: Icon(Icons.backspace, color: Colors.black),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
