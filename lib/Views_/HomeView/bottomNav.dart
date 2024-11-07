import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../reuse_widgets/AppColors.dart';
import 'Controller/bottomNav_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final BottomNavController bn = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return BottomBarDefault(
      indexSelected: bn.currentIndex,
      items: bn.items,
      paddingVertical: 20.h,
      backgroundColor: Colors.white,
      color: Colors.grey,
      colorSelected: AppColors.primaryColor,
      onTap: (index) {
        bn.currentIndex = index;
        bn.update();
      },
     // animated: true,
    );
  }
}
