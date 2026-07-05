import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../Notification/controller/controller.dart';
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
  NotificationController get controller => Get.find<NotificationController>();

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
  NotificationController get controller => Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 46.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: CircleAvatar(
          radius: 17.r,
          backgroundImage: NetworkImage(avatarUrl),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hi, $username',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
      actions: actions ??
          [
            GetBuilder<NotificationController>(
              init: Get.isRegistered<NotificationController>()
                  ? Get.find<NotificationController>()
                  : Get.put(NotificationController(), permanent: true),
              builder: (v) {
              return Badge(
                offset: Offset(-3, 3),
                label: Text(v.unreadCount.toString(), style: TextStyle(fontSize: 8.sp)),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(IconlyLight.notification, color: Colors.black, size: 20.sp),
                  onPressed: () {
                    v.notificationsUnread();
                    Get.to(() => NotificationView());
                  },
                ),
              );
            }),
            SizedBox(width: 12.w),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
