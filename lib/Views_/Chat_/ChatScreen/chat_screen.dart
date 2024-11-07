
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Models/chat_model.dart';
import 'Widgets/chat_item.dart';
import 'Widgets/custom_textfield.dart';

class ChatScreen extends StatelessWidget {
   ChatScreen({super.key});

   List<ChatModel> chats = [
     ChatModel(userId: 1,message: "I am doing great. Thanks for asking dude",createdAt: DateTime.now()),
     ChatModel(userId: 1,message: "wahts up with u?",createdAt: DateTime.now()),
     ChatModel(userId: 1,message: "wahts up with u?",createdAt: DateTime.now()),
     ChatModel(userId: 2,message: "Hello",createdAt: DateTime.now().subtract(const Duration(days: 1))),
     ChatModel(userId: 2,message: "How r u bruhh?",createdAt: DateTime.now().subtract(const Duration(days: 1))),
     ChatModel(userId: 2,message: "Its been a while huh",createdAt: DateTime.now().subtract(const Duration(days: 1))),
     ChatModel(userId: 2,message: "Hey its me ",createdAt: DateTime.now().subtract(const Duration(days: 1))),
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1aafd3),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const Icon(Icons.arrow_back,color: Colors.white,),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff1aafd3),
        title: Text("Messages",style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [

                  Container(
                    width: 36.w,
                    height: 36.w,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black
                    ),
                    child: const Icon(Icons.person,color: Colors.white,),
                  ),

                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text("Christiany"),

                        SizedBox(height: 4.h),

                        const Text("Ortho")

                      ],
                    ),
                  ),

                  Expanded(child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                      ),
                      child: const Icon(Icons.more_vert_outlined),
                    ),
                  ),)

                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.76,
              //width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(48.r),
                  topRight: Radius.circular(48.r),
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: chats.length,
                        itemBuilder: (context,index){
                          var chat = chats[index];
                          return ChatItem(
                            isUser: chat.userId == 1,
                            chat: chat,
                          );
                        }
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 48.h,
                      child: CustomTextField(
                        textInputType: TextInputType.text,
                        fillColor: const Color(0xfff5f5f5),
                        borderRadius: 30,
                        onChanged: (v){},
                        hintText: "Enter a message",
                        prefixIcon: Container(
                          width: 20.w,
                          height: 20.w,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: const BoxDecoration(
                            color: Color(0xff1aafd3),
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.image,color: Colors.white),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Container(
                              width: 30.w,
                              height: 30.w,
                              margin: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle
                              ),
                              child: const Center(
                                child: Icon(Icons.attach_file),
                              ),
                            ),

                            Container(
                              width: 30.w,
                              height: 30.w,
                              margin: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: const BoxDecoration(
                                  color: Color(0xff1aafd3),
                                  shape: BoxShape.circle
                              ),
                              child: const Center(
                                child: Icon(Icons.mic,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 12.h,
                    )

                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
