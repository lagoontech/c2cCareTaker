import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppColors.dart';

/// Reusable empty-state placeholder with icon, title, and optional subtitle.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.minHeight,
    this.action,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final double? minHeight;
  final Widget? action;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  /// Wraps [EmptyStateView] for pull-to-refresh screens.
  static Widget scrollable({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    double? minHeight,
    Widget? action,
    Color? iconColor,
  }) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        EmptyStateView(
          icon: icon,
          title: title,
          subtitle: subtitle,
          minHeight: minHeight ?? MediaQuery.of(context).size.height * 0.55,
          action: action,
          iconColor: iconColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primaryColor;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: minHeight ?? 0,
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding:
                padding ?? EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(22.r),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize ?? 52.sp,
                    color: color,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
                if (action != null) ...[
                  SizedBox(height: 16.h),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
