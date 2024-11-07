import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Notification/controller/controller.dart';
import '../Notification/notification view.dart';
import '../Views_/Notifications/Notification_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions; // Accept a list of actions
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.bottom,
  }) : super(key: key);
  NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leading: leading ?? const SizedBox(),
      title: Text(
        title ?? '',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
      ),
      bottom: bottom,
      centerTitle: true,
      actions: actions ?? [const SizedBox()], // Use the list of actions
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String subtitle;
  final String avatarUrl;
  final List<Widget>? actions;

  HomeAppBar({
    required this.username,
    required this.subtitle,
    required this.avatarUrl,
    this.actions,
  });
  NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Adjust height as needed
      child: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $username',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        actions: actions ??
            [
              IconButton(
                icon: Icon(IconlyLight.search, color: Colors.black),
                onPressed: () {
                  // Handle search action
                },
              ),
              GetBuilder<NotificationController>(builder: (v) {
                return Badge(
                  offset: Offset(-5, 3),
                  label: Text(v.unreadCount.toString()),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(IconlyLight.notification, color: Colors.black),
                    // Adjust icon color
                    onPressed: () {
                      v.notificationsUnread();
                      Get.to(() =>NotificationView());
                    },
                  ),
                );
              }),
              SizedBox(width: 16.w),
            ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
