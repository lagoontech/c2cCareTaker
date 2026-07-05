import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../Notification/controller/controller.dart';
import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/appBar.dart';
import '../../reuse_widgets/customLabel.dart';
import '../../reuse_widgets/empty_state_view.dart';
import '../../reuse_widgets/image_background.dart';
import '../../reuse_widgets/sizes.dart';

class NotificationView extends StatefulWidget {
  NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.allNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: AppColors.primaryColor)),
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
            child: GetBuilder<NotificationController>(
              builder: (v) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
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
                        TextButton(
                          onPressed: () => v.notificationsUnread(),
                          child: CustomLabel(
                            text: "Mark all as read",
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    kHeight10,
                    if (v.listNotification.isEmpty)
                      EmptyStateView(
                        icon: Icons.notifications_none_rounded,
                        title: 'No notifications yet',
                        subtitle:
                            'New updates and appointment alerts will appear here.',
                        minHeight: MediaQuery.of(context).size.height * 0.62,
                      )
                    else
                      ...v.listNotification.map((item) {
                        final title = item.data?.title ?? '';
                        final body = item.data?.body ?? '';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: CustomNotification(
                            icon: IconlyBold.calendar,
                            circleColor: const Color(0xfffafcf9),
                            iconColor: AppColors.primaryColor,
                            heading: title,
                            message: body,
                            notificationId: item.id,
                            showViewAppointment:
                                controller.isAppointmentNotificationText(
                              title,
                              body,
                            ),
                            onViewAppointment: () {
                              controller.openAppointmentFromNotificationText(
                                title,
                                body,
                              );
                            },
                          ),
                        );
                      }),
                  ],
                );
              },
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
  final String? notificationId;
  final bool showViewAppointment;
  final VoidCallback? onViewAppointment;

  CustomNotification({
    super.key,
    this.heading,
    this.message,
    this.icon,
    this.circleColor,
    this.iconColor,
    this.notificationId,
    this.showViewAppointment = false,
    this.onViewAppointment,
  });
  final NotificationController controller = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notificationId ?? '$heading-$message'),
      direction: DismissDirection.endToStart,
     /* background: Container(
        color: AppColors.primaryColor.withOpacity(0.8),
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),*/
      onDismissed: (direction) {
        if (notificationId != null) {
          controller.deleteNotification(notificationId!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted'),
          ),
        );
      },
      /*secondaryBackground: Container(
        color: AppColors.primaryColor.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 20.w),
          ],
        ),
      ),*/
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.13,
        ),
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
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.10,
                  ),
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
                      if (showViewAppointment) ...[
                        SizedBox(height: 6.h),
                        GestureDetector(
                          onTap: onViewAppointment,
                          child: Text(
                            "View appointment",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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
