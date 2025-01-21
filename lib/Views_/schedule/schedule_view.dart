import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(
          leading:
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
          title: "Schedule",
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.43,
                width: MediaQuery.of(context).size.width,
                child: TableCalendar(
                  calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle)),
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2024, 01, 01),
                  lastDay: DateTime.utc(2050, 01, 01),
                ),
              ),
              kHeight10,
              CustomLabel(text: "Waiting Patients"),
              kHeight5,
              WaitingPatients(
                name: 'Akash Asokan ',
                date: '09 AUG 2024',
                imgurl: "assets/images/Rectangle 4482.png",
                time: "Monday 8:00AM - 9:00AM",
              ),
              kHeight5,
              WaitingPatients(
                name: 'Sujin Kumar',
                date: '09 AUG 2024',
                imgurl: "assets/images/Rectangle 4486.png",
                time: "Monday 8:00AM - 9:00AM",
              ),
              kHeight5,
              WaitingPatients(
                name: 'Anlin Jude',
                date: '09 AUG 2024',
                imgurl: "assets/images/Rectangle 4481.png",
                time: "Monday 8:00AM - 9:00AM",
              ),
              kHeight10,
            ],
          ).paddingSymmetric(horizontal: 10.w),
        ));
  }
}

class WaitingPatients extends StatelessWidget {
  final String? name;
  final String? date;
  final String? time;
  String? status;
  int?appoinId;
  int?patientId;
  final String? imgurl;
  VoidCallback? onTapButton;
  VoidCallback? onTapDialog;
  final bool? showIcon; // New parameter to control icon visibility

  WaitingPatients({
    this.name,
    this.date,
    this.imgurl,
    this.time,
    this.patientId,
    this.appoinId,
    this.status,
    this.onTapDialog,
    this.onTapButton,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(7.r)),
      color: Colors.white,
      type: MaterialType.card,
      elevation: 2,
      child: InkWell(
        onTap: onTapDialog,
        child: Container(
          padding: EdgeInsets.all(6.r),
          height: 80.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(),
          child: Stack(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.r),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: 120.w,
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Image.network(imgurl ?? '',fit: BoxFit.fitWidth),
                      ),
                    ),
                  ),
                  kWidth10,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.sp),
                      ),
                      Text(
                        date ?? '',
                        style:
                            TextStyle(fontSize: 13.sp, color: Color(0xffB9B9B9)),
                      ),
                      Text(
                        time ?? '',
                        style:
                            TextStyle(fontSize: 13.sp, color: Color(0xffB9B9B9)),
                      ),
                    ],
                  ),
                ],
              ),
              if (status != null)
                Positioned(
                  top: 8,
                  right: showIcon == true ? 48 : 8,
                  // Adjust position if icon is shown
                  child: Text(
                    '${status![0].toUpperCase()}${status!.substring(1)}',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.green, // Customize color
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (showIcon!)
                Positioned(
                  top: -12,
                  right: -12,
                  child: IconButton(
                    onPressed: onTapButton,
                    icon: const Icon(Icons.more_vert_outlined),
                  ),
                ),
            ],
          ),
        ).paddingAll(8.r),
      ),
    );
  }
}
