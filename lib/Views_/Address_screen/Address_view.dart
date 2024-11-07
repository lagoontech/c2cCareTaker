import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  String selectedValue = ''; // Track the selected value for the radio button

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: 'Address',
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          children: [
            addressCustom(
              context,
              title: "Home",
              street: "1234 Elm Street",
              city: "Springfield, IL 62704",
              country: "USA",
            ),
            kHeight10,
            addressCustom(
              context,
              title: "Work",
              street: "5678 Oak Avenue",
              city: "Metropolis, IL 62960",
              country: "USA",
            ),
            kHeight20,

            DottedBorder(
                stackFit: StackFit.loose,
                color: AppColors.primaryColor,
                child: Container(
                  height: 40.h,
                  child: Center(
                    child: Text("Add New Address",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        )),
                  ),
                ))
            // Add more addresses as needed
          ],
        ),
      ),
    );
  }

  Widget addressCustom(
    BuildContext context, {
    required String title,
    required String street,
    required String city,
    required String country,
  }) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 20.w),
          ],
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 9),
            ),
          ],
          borderRadius: BorderRadius.circular(12.r),
          color: CupertinoColors.white,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/Map (1).png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.location_on,
                            size: 30.sp,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        street,
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        city,
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        country,
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8.r,
              right: 8.r,
              child: Radio<String>(
                value: title,
                // The value this radio represents
                groupValue: selectedValue,
                // The currently selected value
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!; // Update selected value
                  });
                },
                activeColor: Colors.black.withOpacity(0.8),
                fillColor: MaterialStateProperty.all(
                  AppColors.primaryColor.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
