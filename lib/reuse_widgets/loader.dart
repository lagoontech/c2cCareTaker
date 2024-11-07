import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomCircularLoader extends StatefulWidget {
  const CustomCircularLoader({super.key, this.color, this.height, this.width});

  final double? width;
  final double? height;
  final Color? color;

  @override
  CustomCircularLoaderState createState() => CustomCircularLoaderState();
}

class CustomCircularLoaderState extends State<CustomCircularLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 20,
      height: widget.height ?? 20,
      child: SpinKitCircle(
        color: widget.color ?? Colors.white,
        size: widget.width ?? 50.0,
        controller: controller,
      ),
    );
  }
}
