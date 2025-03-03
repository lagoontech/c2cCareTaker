import 'dart:isolate';
import 'dart:ui';
import 'package:care2caretaker/Notification/controller/controller.dart';
import 'package:care2caretaker/Views_/HomeView/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Views_/Notifications/Notification_view.dart';
import 'Views_/SplashScreen/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "main",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(NotificationController());
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  runApp(const MyApp());

}

//
@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message)async {

  if(kDebugMode){
    print("Background message: " + "${message.data}");
  }
  final SendPort? sendPort = IsolateNameServer.lookupPortByName('requests_loader');
  if (sendPort != null) {
    sendPort.send("load");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return ScreenUtilInit(builder: (context, w) {
      return GetMaterialApp(
        getPages: [
          GetPage(name: '/home', page: () => HomeView()),
          GetPage(name: '/notification', page: () => NotificationView()),
        ],
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.native,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff15ADD2),
          ),
          fontFamily: GoogleFonts.kumbhSans().fontFamily,
          applyElevationOverlayColor: false,
          useMaterial3: true,
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Color(0xff222222)),
          ),
        ),
        home: const SplashScreen(),
      );
    });
  }
}