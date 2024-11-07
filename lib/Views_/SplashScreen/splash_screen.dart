import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/image_background.dart';
import '../../reuse_widgets/loader.dart';
import '../../reuse_widgets/sizes.dart';
import '../Auth_screen/Sigin_screen/signIn_view.dart';
import '../HomeScreen/home-screen.dart';
import '../HomeView/home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool foundUser = false;

  @override
  void initState() {
    super.initState();
    tokenCheck();
  }

  tokenCheck() async {
    bool isDetailsComplete = await SharedPref().getRegisterComplete();
    Future.delayed(const Duration(seconds: 1), () {
      if (isDetailsComplete) {
        Get.off(() => HomeView());
      } else {
        Get.off(() => MobileEmail());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'assets/images/svg/logo.svg',
              fit: BoxFit.cover
              ,
            ),
          ),
          kHeight10,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: CustomCircularLoader(
                height: 50.h,
                width: 50.w,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
