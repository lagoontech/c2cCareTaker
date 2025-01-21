import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextField(BuildContext context,
    {TextInputType? textInputType,
      Widget? prefix,
      String hint = "",
      double? borderRadius = 8,
      Color? borderColor,
      Color? fillColor,
      double? height,
      double?width,
      Widget? suffix,
      bool autofocus = false,
      bool obscureText = false,
      bool readOnly = false,
      Color? color,
      Function()? onTap,
      EdgeInsetsGeometry? contentPadding,
      TextCapitalization? textCapitalization,
      TextEditingController? controller,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator,
      Function(String?)? onSaved,
      Function(String?)? onChanged,
      TextInputAction? textInputAction,
      int? maxLength,
      int? maxLines,
      String? labelText,
      String? errorText,
      TextStyle? labelStyle,
      TextStyle? hintStyle,
      TextStyle? textStyle,
    }) {
  return Container(
    height: height,
    width: width,
    child: TextFormField(
      onChanged: onChanged,
      cursorWidth: 2,
      autofocus: autofocus,
      onTap: onTap,
      readOnly: readOnly,
      keyboardAppearance: Brightness.dark,
      textInputAction: textInputAction ?? TextInputAction.done,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: textInputType ?? TextInputType.text,
      style: textStyle ??  TextStyle(fontSize: 15.sp, color: Colors.black),
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      onSaved: onSaved,
      decoration: InputDecoration(
        disabledBorder: InputBorder.none,
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.3)),
        isDense: true,
        filled: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
        fillColor: fillColor ?? Colors.white.withOpacity(0.2),
        counterText: "",
        prefixIcon: prefix ,
        suffixIcon: suffix,
        hintText: hint,
        errorText: errorText,
        hintStyle: hintStyle ?? TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: "verdana_regular"
        ),
        labelText: labelText ?? 'Email/Mobile',
        labelStyle: labelStyle ?? TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: "verdana_regular"
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always, // Always show the label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey, // Default to showing the border
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey, // Default to showing the border
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.blue, // Show blue border when focused
            width: 1.0,
          ),
        ),
      ),
    ),
  );
}

Widget customDropdown(BuildContext context,
    {TextInputType? textInputType,
      Widget? prefix,
      String hint = "",
      double? borderRadius = 8,
      Color? borderColor,
      Color? fillColor,
      double? height,
      Widget? suffix,
      bool autofocus = false,
      bool obscureText = false,
      bool readOnly = false,
      Color? color,
      Function()? onTap,
      EdgeInsetsGeometry? contentPadding,
      TextCapitalization? textCapitalization,
      TextEditingController? controller,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator,
      Function(String?)? onSaved,
      TextInputAction? textInputAction,
      int? maxLength,
      int? maxLines,
      String? labelText,
      String? errorText,
      TextStyle? labelStyle,
      TextStyle? hintStyle,
      TextStyle? textStyle,
      List<DropdownMenuItem<dynamic>> ?items,
      Function(dynamic) ?onChanged,
      dynamic value
    }) {
  return Container(
    height: height,
    child: DropdownButtonFormField(
      autofocus: autofocus,
      onTap: onTap,
      value: value,
      decoration: InputDecoration(
        disabledBorder: InputBorder.none,
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.3)),
        isDense: true,
        filled: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
        fillColor: fillColor ?? Colors.white.withOpacity(0.2),
        counterText: "",
        prefixIcon: prefix ,
        suffixIcon: suffix,
        hintText: hint,
        errorText: errorText,
        hintStyle: hintStyle ?? TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: "verdana_regular"
        ),
        labelText: labelText ?? 'Email/Mobile',
        labelStyle: labelStyle ?? TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: "verdana_regular"
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always, // Always show the label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey, // Default to showing the border
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey, // Default to showing the border
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.blue, // Show blue border when focused
            width: 1.0,
          ),
        ),
      ), items: items, onChanged: onChanged,
    ),
  );
}

