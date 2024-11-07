/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'controller.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Push Notifications with GetX')),
        body: GetBuilder<NotificationController>(
            builder: (controller) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('FCM Token:'),
                    SelectableText(controller.fcmToken ?? 'No token'),
                    SizedBox(height: 20),
                    Text('Latest Message:'),
                    Text(controller.latestMessage ?? 'No messages yet'),
                  ],
                ),
              );
            },
            ),
        );
    }
}*/
