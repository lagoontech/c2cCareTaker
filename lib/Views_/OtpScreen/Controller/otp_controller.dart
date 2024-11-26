import 'dart:convert';

import 'package:care2caretaker/Views_/HomeView/home_view.dart';
import 'package:care2caretaker/Views_/Profile/Controller/profileController.dart';
import 'package:care2caretaker/api_urls/url.dart';
import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../reuse_widgets/customToast.dart';
import '../../Profile/profile_view.dart';

class OtpController extends GetxController {
  final profileController = Get.put(ProfileController());
  TextEditingController otpTEC = TextEditingController();
  bool isLoading = false;

  checkOtp(String? mobilnum) async {
    String? otp = await SharedPref().getOtp();
    print("sharedPref$otp");
    if (otpTEC.text.length != 4) {
      showCustomToast(message: "OTP must be exactly 4 digits");
      return;
    }
    if (otpTEC.text != otp) {
      showCustomToast(message: "Please entered correct otp");
      isLoading = false;
      update();
      return;
    }

    isLoading = true;
    update();

    // try {
    var res = await http.post(Uri.parse(URls().checkOtp), body: {
      "mobilenum": mobilnum,
      "otp": otpTEC.text,
    });
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      debugPrint("check otp body : $json");
      var token = json['token'];
      await SharedPref().saveToken(token);
      debugPrint("otp check After Store Token $token");
      await profileController.fetchCareTakerDetails();

      if (profileController.profileList != null &&
          profileController.profileList!.data!.caretakerInfo != null) {
        Get.offAll(() => HomeView());
      } else {
        Get.offAll(() => ProfileView());
      }
      update();

      if (profileController.profileList != null &&
          profileController.profileList!.data!.caretakerInfo != null) {
        onUserDetailsCompleted();
      }
      update();
    } else {
      debugPrint("otp check Not Successful");
    }
    /*  } catch (e) {
      debugPrint(e.toString());
    }*/
    isLoading = false;
    update();
  }

  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }

 /* @override
  void onClose() {
    otpTEC.dispose();
    super.onClose();
  }*/
}
