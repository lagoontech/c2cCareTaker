import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'AppColors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.icon,
    this.isLoading = false,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onPressed() {
    if (widget.isLoading || widget.onPressed == null) return;

    setState(() {
      _scale = 0.9; // Scale down
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });

      widget.onPressed!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _onPressed, // Handle button tap
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 40.h,
            decoration: BoxDecoration(
              color: widget.color ?? AppColors.primaryColor,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 22.r),
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                width: 25.w,
                height: 23.h,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      widget.textColor ?? Colors.white),
                  strokeWidth: 2.0,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Icon(
                      widget.icon,
                      color: widget.textColor ?? Colors.white,
                    ),
                  SizedBox(width: 12.w),
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.textColor ?? Colors.white,
                      fontSize: widget.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
