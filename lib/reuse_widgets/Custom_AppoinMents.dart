import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppColors.dart';


class AppointmentsContainer extends StatelessWidget {
  final String imageUrl;
  final Color? statusColor;
  final String appointmentDate;
  final String appointmentTime;
  final String ?doctorName;
  final String ?doctorDesignation;
  final String? action;
  final Color? actionColor;
  final IconData? actionIcon;

  const AppointmentsContainer(
      {super.key,
      required this.imageUrl,
      this.statusColor,
      this.actionColor,
      required this.appointmentDate,
      required this.appointmentTime,
       this.doctorName,
       this.doctorDesignation,
      this.action,
      this.actionIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(

          // color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(width: 0.2, color: Colors.grey)),
      child: Row(
        children: [
          // Left border strip
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.02,
            decoration: BoxDecoration(
              color: statusColor ?? AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                topLeft: Radius.circular(10.r),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.r),
              // Adjusted padding inside the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Appointments Details",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert_outlined),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        appointmentDate ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '\u2022',
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          appointmentTime ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(height: 5.h),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundImage: NetworkImage(imageUrl ?? ''),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorName ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                doctorDesignation ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                actionIcon != null
                                    ? Icon(
                                        actionIcon,
                                        size: 20.sp,
                                        color: AppColors.secondaryColor,
                                      )
                                    : SizedBox(),
                                SizedBox(width: 5.w),
                                Text(
                                  action ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: actionColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
