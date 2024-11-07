
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?> onChanged;
  final Color? selectedColor; // Color for the selected state
  final Color? unselectedColor; // Color for the unselected state

  CustomRadioButton({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    final Color? containerColor = isSelected ? selectedColor : unselectedColor;

    return Container(
      height: 30.h,
      padding: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: Colors.grey, width: 0.2)),
      child: Row(
        children: [
          Radio<T>(activeColor: Colors.white,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(label),
        ],
      ),
    );
  }
}
