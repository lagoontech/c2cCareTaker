import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';

import '../../Notification/controller/controller.dart';
import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/appBar.dart';
import '../../reuse_widgets/customLabel.dart';
import '../../reuse_widgets/image_background.dart';
import '../../reuse_widgets/sizes.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: 10.w,
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    color: AppColors.primaryColor,
                  )),
            )
          ],
          title: "Notification",
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.allNotifications();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomLabel(
                        text: "Today",
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomLabel(
                        text: "Mark all as read",
                        fontSize: 12.sp,
                        color: Colors.black),
                  ],
                ),
                kHeight10,
                GetBuilder<NotificationController>(builder: (v) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: v.listNotification.length,
                        itemBuilder: (context, index) {
                          var data = v.listNotification[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: InkWell(
                              onTap: () {},
                              child: CustomNotification(
                                icon: IconlyBold.calendar,
                                circleColor: Color(0xfffafcf9),
                                iconColor: AppColors.primaryColor,
                                heading: data.data!.title,
                                message: data.data!.body,
                              ),
                            ),
                          );
                        }),
                  );
                }),
                kHeight10,
                CustomNotification(
                  icon: IconlyBold.calendar,
                  circleColor: Color(0xfffdeef1),
                  iconColor: Colors.red,
                  heading: 'Your appointment placed successfully',
                  message:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                ),
                kHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomLabel(
                        text: "Old",
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomLabel(
                        text: "Mark all as read",
                        fontSize: 12.sp,
                        color: Colors.black),
                  ],
                ),
                kHeight10,
                CustomNotification(
                  icon: IconlyBold.calendar,
                  circleColor: Color(0xfffafcf9),
                  iconColor: AppColors.primaryColor,
                  heading: 'Your appointment placed successfully',
                  message:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                ),
                kHeight10,
                CustomNotification(
                  icon: IconlyBold.calendar,
                  circleColor: Color(0xfffafcf9),
                  iconColor: AppColors.primaryColor,
                  heading: 'Your appointment placed successfully',
                  message:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                ),
                kHeight10,
                CustomNotification(
                  icon: IconlyBold.calendar,
                  circleColor: Color(0xfffafcf9),
                  iconColor: AppColors.primaryColor,
                  heading: 'Your appointment placed successfully',
                  message:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                ),
                kHeight10,
                CustomNotification(
                  icon: IconlyBold.calendar,
                  circleColor: Color(0xfffafcf9),
                  iconColor: AppColors.primaryColor,
                  heading: 'Your appointment placed successfully',
                  message:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                ),
              ]),
            ),
          ),
        ));
  }
}

class CustomNotification extends StatelessWidget {
  final String? heading;
  final String? message;
  final IconData? icon;
  final Color? circleColor;
  final Color? iconColor;

  CustomNotification({
    super.key,
    this.heading,
    this.message,
    this.icon,
    this.circleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: AppColors.primaryColor.withOpacity(0.8),
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.primaryColor.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 20.w),
          ],
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.09),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: circleColor ?? Colors.blue,
                child: Icon(
                  icon ?? Icons.notifications,
                  size: 22,
                  color: iconColor ?? Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5), // Replace kHeight5 with SizedBox
                      Text(
                        heading ?? "Notification",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        message ?? "This is a notification message.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
