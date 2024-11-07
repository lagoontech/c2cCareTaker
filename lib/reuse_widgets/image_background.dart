import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final BoxFit fit;
  final Widget ?floatingActionButton;
  final Widget ?bottomNavBar;
  final PreferredSizeWidget? appBar;


  const CustomBackground({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavBar,
    this.floatingActionButton,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar:appBar ,
      bottomNavigationBar: bottomNavBar,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:  const AssetImage("assets/images/Seamless pattern bg1.png"),
                fit: fit,
              ),
            ),
          ),
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
