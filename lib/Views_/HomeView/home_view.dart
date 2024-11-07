import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../reuse_widgets/image_background.dart';
import 'Controller/bottomNav_controller.dart';
import 'bottomNav.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BottomNavController bn = Get.put(BottomNavController());
  DateTime? _lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (bn.currentIndex == 0) {
      if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > Duration(seconds: 2)) {
        // If this is the first press or the time between presses is more than 2 seconds, show warning
        _lastBackPressTime = now;
        CustomToast.show(context, 'Press back again to exit');
        return Future.value(false); // Return false to prevent the default back navigation
      }
      // If the time between presses is less than 2 seconds, exit the app
      return Future.value(true); // Return true to allow the default back navigation
    } else {
      // If currentIndex is not 0, navigate back to the first screen
      bn.currentIndex = 0;
      bn.update(); // Notify the controller to update the view
      return Future.value(false); // Return false to prevent the default back navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<BottomNavController>(
        builder: (vv) {
          return CustomBackground(
            bottomNavBar: BottomNavBar(),
            child: bn.screens[bn.currentIndex],
          );
        },
      ),
    );
  }
}

class CustomToast {
  static void show(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
