import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
   CustomTextField({
     Key? key,
     this.borderRadius=0,
     this.outlineWidth=1,
     this.filled=true,
     this.fieldFocused=false,
     this.obscureText=false,
     this.fillColor=Colors.white,
     this.hintText='',
     this.suffixIcon,
     this.onSuffixTap,
     required this.textInputType,
     this.maxLength,
     this.validator,
     this.prefixIcon,
     this.onChanged,
     this.onSaved,
     this.controller,
     this.borderColor,
     this.enableLabel = true,
     this.prefix,
     this.suffix
   }) : super(key: key);

   //
  double borderRadius;
  double outlineWidth;
  bool filled;
  Color fillColor;
  Color ?borderColor;
  String hintText;
  Widget ?prefixIcon;
  Widget ?suffixIcon;
  bool fieldFocused;
  bool obscureText;
  bool enableLabel;
  Widget ?prefix;
  Widget ?suffix;

  //
   TextInputType textInputType;
   int ?maxLength;
   Function(bool) ?onSuffixTap;
   Function(String) ?onChanged;
   Function(String?) ?onSaved;
   String? Function(String?) ?validator;
   TextEditingController ?controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      maxLength: maxLength,
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: 11.sp),
      decoration: InputDecoration(
          prefix: prefix,
          suffix: suffix,
          isDense: true,
          counter: const SizedBox(),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: enableLabel ? hintText : '',
          labelStyle: TextStyle(color: const Color(0xffbdbdbd),fontSize: 11.sp),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xffbdbdbd),fontSize: 11.sp),
          filled: filled,
          fillColor: fillColor,
          errorStyle: TextStyle(
              color: Colors.red,
              fontSize:8.sp
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: outlineWidth
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color:  borderColor ?? Colors.transparent,
                  width: outlineWidth
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: outlineWidth
              )
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: outlineWidth
              )
          )
      ),
    );
  }
}
