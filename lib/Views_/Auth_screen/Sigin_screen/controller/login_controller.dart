import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:care2caretaker/api_urls/url.dart';
import 'package:care2caretaker/reuse_widgets/customToast.dart';
import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../../OtpScreen/otp_screen.dart';

class LoginController extends GetxController {

  TextEditingController phoneCT = TextEditingController();
  FocusNode focusNode           = FocusNode();
  GoogleSignIn googleSignIn     = GoogleSignIn();
  bool isLoading                = false;
  CountryCode? countryCode      = CountryCode.fromDialCode('+91');
  int? getOtp;
  String? fcmToken;

  Future<void> getFcmToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      bool android = Platform.isAndroid;
      if(android){
        fcmToken = await FirebaseMessaging.instance.getToken();
      }else {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      print("Fetched FCM Token: $fcmToken");
    } catch (e) {
      print("Error fetching FCM Token: $e");
      showCustomToast(
          message: "Failed to retrieve FCM token. Please try again.");
    }
  }

  Future<void> updateFCMTokenOnServer(String newToken) async {
   /* try {*/
      String? patientId = await SharedPref().getId();

      if (patientId != null) {
        var response = await http.post(
          Uri.parse(URls().UpdateFCMToken),
          body: {
            'caretaker_id': patientId,
            'fcm_token': newToken,
          },
        /*  headers: {
            "Content-Type": "application/json",
          },*/
        );

        if (response.statusCode == 200) {
          print("FCM Token updated successfully.");
        } else {
          print("Failed to update FCM Token: ${response.body}");
        }
      } else {
        print("Patient ID is not available.");
      }
 /*   } catch (e) {
      print("Error updating FCM Token on server: $e");
    }*/
  }

  /*Future<void> getFcmToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    print("Fetched FCM Token: $fcmToken");
  }*/
  loginorRegister({required BuildContext context}) async {
    isLoading = true;
    update();
    // Ensure that the countryCode is not null before proceeding
    if (countryCode == null) {
      showCustomToast(message: "Please select a country code.");
      isLoading = false;
      update();
      return;
    }
    String selectedCountryCode = countryCode?.dialCode ?? '+91';
    int maxPhoneNumberLength = phoneNumberLengths[selectedCountryCode] ?? 10;
    if (phoneCT.text.length != maxPhoneNumberLength) {
      showCustomToast(
          message:
              "Please enter a valid phone number for ${countryCode!.name}");
      print(countryCode!.name);
      isLoading = false;
      update();
      return;
    }
    await getFcmToken();
    if (fcmToken == null) {
      showCustomToast(message: "FCM token is not available. Please try again.");
      isLoading = false;
      update();
      return;
    }

    try {
      var result = await http.post(Uri.parse(URls().loginorsignup), body: {
        'mobilenum': phoneCT.text,
        'fcm_token': fcmToken,
      });
      if (result.statusCode == 200) {
        var responseBody = jsonDecode(result.body);
        int getOtp = responseBody['otp'];
        await SharedPref().saveOtp(getOtp.toString());
        int patientId = responseBody['caretaker']['id'];
        await SharedPref().saveId(patientId.toString());
        debugPrint('your otp is : $getOtp');
        showCustomToast(message: "your otp is $getOtp");
        Get.to(() => OtpScreen(
              phone: phoneCT.text,
            ));
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    update();
  }

  googleSignInAccount() async {
    try {
      GoogleSignInAccount? acc = await googleSignIn.signIn();
      GoogleSignInAuthentication accAuth = await acc!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: accAuth.accessToken,
        idToken: accAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      User? user = userCredential.user;
      debugPrint(user.toString());
    } catch (e) {}
  }

  Map<String, int> phoneNumberLengths = {
    '+1': 10, // USA, Canada
    '+91': 10, // India
    '+971': 9, // UAE
    '+44': 10, // UK
    '+61': 9, // Australia
    '+81': 10, // Japan
    '+86': 11, // China
    '+33': 9, // France
    '+49': 10, // Germany
    '+39': 10, // Italy
    '+34': 9, // Spain
    '+55': 11, // Brazil
    '+7': 10, // Russia
    '+27': 9, // South Africa
    '+32': 9, // Belgium
    '+351': 9, // Portugal
    '+52': 10, // Mexico
    '+31': 9, // Netherlands
    '+47': 8, // Norway
    '+46': 9, // Sweden
    '+41': 9, // Switzerland
    '+90': 10, // Turkey
    '+62': 11, // Indonesia
    '+63': 10, // Philippines
    '+64': 9, // New Zealand
    '+82': 10, // South Korea
    '+60': 10, // Malaysia
    '+66': 9, // Thailand
    '+372': 8, // Estonia
    '+370': 8, // Lithuania
    '+420': 9, // Czech Republic
    '+385': 9, // Croatia
    '+386': 9, // Slovenia
    '+48': 9, // Poland
    '+30': 10, // Greece
    '+359': 9, // Bulgaria
    '+370': 9, // Lithuania
    '+375': 9, // Belarus
    '+380': 9, // Ukraine
    '+373': 8, // Moldova
    '+374': 8, // Armenia
    '+994': 9, // Azerbaijan
    '+90': 10, // Turkey
    '+92': 10, // Pakistan
    '+94': 9, // Sri Lanka
    '+965': 8, // Kuwait
    '+973': 8, // Bahrain
    '+974': 8, // Qatar
    '+968': 8, // Oman
    '+965': 8, // Kuwait
    '+212': 9, // Morocco
    '+216': 8, // Tunisia
    '+213': 9, // Algeria
    '+20': 10, // Egypt
    '+234': 10, // Nigeria
    '+256': 9, // Uganda
    '+254': 9, // Kenya
    '+255': 9, // Tanzania
    '+263': 9, // Zimbabwe
    '+268': 8, // Eswatini (Swaziland)
    '+675': 8, // Papua New Guinea
    '+84': 9, // Vietnam
    '+855': 9, // Cambodia
    '+856': 8, // Laos
    '+64': 9, // New Zealand
    '+686': 8, // Kiribati
    '+679': 7, // Fiji
    '+680': 7, // Palau
    '+675': 8, // Papua New Guinea
    '+689': 6, // French Polynesia
    '+678': 7, // Vanuatu
    '+685': 5, // Samoa
  };

  @override
  void onInit() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateFCMTokenOnServer(newToken);
    });
    //getFcmToken();
    super.onInit();
  }
}
