import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ChatScreen/Widgets/custom_textfield.dart';
import 'Models/chat_list_model.dart';
import 'Widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  List<ChatListModel> chatList = [
    ChatListModel(
      chat: "Hey, how are you?",
      name: "Alice",
      time: "10:30 AM",
    ),
    ChatListModel(
      chat: "Did you complete the project?",
      name: "Bob",
      time: "11:00 AM",
    ),
    ChatListModel(
      chat: "Let's catch up later.",
      name: "Charlie",
      time: "11:30 AM",
    ),
    ChatListModel(
      chat: "Good morning!",
      name: "David",
      time: "09:00 AM",
    ),
    ChatListModel(
      chat: "Can we meet today?",
      name: "Eva",
      time: "01:15 PM",
    ),
    ChatListModel(
      chat: "Don't forget the meeting at 3 PM.",
      name: "Frank",
      time: "02:45 PM",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1aafd3),
      appBar: AppBar(
        backgroundColor: const Color(0xff1aafd3),
        title: Text(
          "Messages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Center(
                child: CustomTextField(
                  textInputType: TextInputType.text,
                  fillColor: const Color(0xfff5f5f5),
                  borderRadius: 12.r,
                  onChanged: (v) {},
                  hintText: "Search care takers...",
                  prefixIcon: Container(
                    width: 20.w,
                    height: 20.w,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: const BoxDecoration(
                      color: Color(0xff1aafd3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.76,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(48.r),
                  topRight: Radius.circular(48.r),
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 36.h),
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  var chat = chatList[index];
                  return ChatListItem(chat: chat);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
        child: FloatingActionButton.small(
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.r),
          ),
          backgroundColor: const Color(0xff1aafd3),
          child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
