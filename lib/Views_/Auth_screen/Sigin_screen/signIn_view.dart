import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';

import '../../../reuse_widgets/customButton.dart';
import '../../../reuse_widgets/custom_textfield.dart';
import '../../../reuse_widgets/image_background.dart';
import '../../../reuse_widgets/sizes.dart';
import 'controller/login_controller.dart';

class MobileEmail extends StatefulWidget {
  MobileEmail({super.key});

  @override
  State<MobileEmail> createState() => _MobileEmailState();
}

class _MobileEmailState extends State<MobileEmail> {
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Column(
        children: [
          kHeight20,
          Expanded(
              flex: 2,
              child: Image.asset("assets/images/Care taker wlkthrgh img.png")),
          kHeight70,
          Flexible(
              //flex: 4,
              child: Column(
            children: [
              CustomButton(
                isLoading: isLoad,
                icon: Icons.phone_iphone_outlined,
                text: 'Continue With Mobile',
                onPressed: isLoad
                    ? null
                    : () async {
                        setState(() {
                          isLoad = true;
                        });
                        await Future.delayed(Duration(seconds: 1));
                        await Get.to(() => LoginScreen());
                        setState(() {
                          isLoad = false;
                        });
                      },
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SizedBox(
                  height: 20.h,
                  //color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: const Text("or continue"),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      kHeight30,
                    ],
                  ),
                ),
              ),
              kHeight20,
              InkWell(
                onTap: () {},
                child: Center(
                    child: SvgPicture.asset(
                  "assets/images/svg/signin_with_google.svg",
                  height: 30.h,
                )),
              )
            ],
          ))
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  LoginController lc = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: SvgPicture.asset(
                  "assets/images/svg/logo.svg",
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AutoSizeText(
                    "Enter your mobile number",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
                  )),
              SizedBox(height: 20.h),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    "We will send you a verification code",
                    textAlign: TextAlign.center,
                    maxLines: null,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600),
                  )),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.r),
                child: customTextField(
                  context,
                  prefix: GetBuilder<LoginController>(builder: (v) {
                    return CountryCodePicker(
                      onChanged: (countryCode) {
                        v.countryCode = countryCode;
                        v.update();
                        print(countryCode);
                      },
                      initialSelection: 'IN',
                      favorite: ['+91', 'FR'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      flagDecoration: BoxDecoration(shape: BoxShape.circle),
                    );
                  }),
                  controller: lc.phoneCT,
                  textStyle: TextStyle(
                    fontSize: 17.sp,
                  ),
                  labelText: 'Phone',
                  readOnly: true,
                ),
              ),
              SizedBox(height: 40.h),
              GetBuilder<LoginController>(builder: (v) {
                print(v.phoneCT.text);
                return CustomButton(
                    isLoading: v.isLoading,
                    width: MediaQuery.of(context).size.width * 0.8,
                    text: "Continue",
                    onPressed: v.isLoading
                        ? null
                        : () => v.loginorRegister(context: context));
              }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: NumericKeyboard(
                  onKeyboardTap: (val) {
                    // Get the selected country code
                    String selectedCountryCode =
                        lc.countryCode?.dialCode ?? '+91';
                    int maxPhoneNumberLength =
                        lc.phoneNumberLengths[selectedCountryCode] ?? 10;

                    if (val == 99) {
                      if (lc.phoneCT.text.isEmpty) {
                        return;
                      }
                      lc.phoneCT.text = lc.phoneCT.text
                          .substring(0, lc.phoneCT.text.length - 1);
                    } else {
                      // Limit the phone number input based on the country's allowed digit length
                      if (lc.phoneCT.text.length >= maxPhoneNumberLength) {
                        return;
                      }
                      lc.phoneCT.text = lc.phoneCT.text + val.toString();
                    }
                    print(
                        "Phone number: ${lc.phoneCT.text} (Country: $selectedCountryCode)");
                    lc.update();
                  },
                  textStyle: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  rightButtonFn: () {
                    if (lc.phoneCT.text.isNotEmpty) {
                      lc.phoneCT.text = lc.phoneCT.text
                          .substring(0, lc.phoneCT.text.length - 1);
                      lc.update();
                    }
                  },
                  rightButtonLongPressFn: () {
                    lc.phoneCT.clear();
                    lc.update();
                  },
                  rightIcon: Icon(
                    Icons.backspace,
                    color: Colors.black,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween),
              clipBehavior: Clip.hardEdge,
            ),
          ),
        ],
      ),
    );
  }

  //
  InputDecoration inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
    );
  }
}
