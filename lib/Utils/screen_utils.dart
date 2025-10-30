import 'package:flutter/cupertino.dart';

bool isiPadLayout(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final shortestSide = size.shortestSide;
  return shortestSide > 600;
}
