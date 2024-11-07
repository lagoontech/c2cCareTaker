
import 'package:care2caretaker/Views_/Chat_/ChatScreen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Models/chat_list_model.dart';

class ChatListItem extends StatelessWidget {
  ChatListItem({super.key, this.chat});

  ChatListModel? chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatScreen());
        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatScreen()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  margin: EdgeInsets.only(left: 20.w),
                  decoration: const BoxDecoration(
                      color: Color(0xff1aafd3), shape: BoxShape.circle),
                  child: Icon(Icons.person, size: 28.sp, color: Colors.white),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat!.name!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          chat!.chat!,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis, fontSize: 12.sp),
                        ))
                  ],
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat!.time!,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: const BoxDecoration(
                            color: Color(0xff1aafd3), shape: BoxShape.circle),
                        child: Center(
                            child: Text(
                          "01",
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.sp),
                        )),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Divider(
              color: Color(0xfff5f5f5),
            )
          ],
        ),
      ),
    );
  }
}
