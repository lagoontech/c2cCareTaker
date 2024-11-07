import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppColors.dart';

class CustomEasyDateTimeLine extends StatelessWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateChange;

  const CustomEasyDateTimeLine({
    Key? key,
    this.initialDate,
    this.onDateChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: initialDate ?? DateTime.now(),
      onDateChange: onDateChange ?? (selectedDate) {},
      activeColor: AppColors.primaryColor,
      headerProps: EasyHeaderProps(showHeader: false),
      dayProps:  EasyDayProps(
        height: 65.h,
        width: 45.w,
        activeDayStyle: DayStyle(
          borderRadius: 33.0,
        ),
        inactiveDayStyle: DayStyle(
          borderRadius: 32.0,
        ),
      ),
      timeLineProps: const EasyTimeLineProps(
        hPadding: 10.0,
        separatorPadding: 16.0,
      ),
    );
  }
}
