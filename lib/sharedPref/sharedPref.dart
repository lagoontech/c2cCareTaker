import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Notification/controller/controller.dart';
import '../Views_/Auth_screen/Sigin_screen/signIn_view.dart';
import '../Views_/HomeScreen/controller/home_controller.dart';
import '../Views_/Profile/Controller/profileController.dart';

class SharedPref {
  saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    debugPrint('Token saved: $token');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    debugPrint('Token retrieved: $token');
    return token;
  }
  saveFCMToken(String fcmToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken);
    debugPrint('FCM Token saved: $fcmToken');
  }

  Future<String?> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fcmToken = prefs.getString('fcm_token');
    debugPrint('FCM Token retrieved: $fcmToken');
    return fcmToken;
  }



  saveId(String ID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', ID);
    debugPrint('id saved: $ID');
  }

  Future<String?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    debugPrint('id retrieved: $id');
    return id;
  }

  saveOtp(String otp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('otp', otp);
    debugPrint('ottp saved: $otp');
  }

  Future<String?> getOtp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('otp');
    debugPrint('otp retrieved: $token');
    return token;
  }

  Future<void> setRegisterComplete(bool isComplete) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isDetailsComplete', isComplete);
  }

  Future<bool> getRegisterComplete() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isDetailsComplete') ?? false;
  }

  Future<void> logout() async {
    Get.delete<ProfileController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<NotificationController>(force: true);
    Get.deleteAll(); // Optionally, delete all controllers if necessary
    // Clear shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    Future.delayed(Duration(milliseconds: 200), () {
      Get.offAll(() => MobileEmail()); // Navigate to the login screen
    });
  }
}
