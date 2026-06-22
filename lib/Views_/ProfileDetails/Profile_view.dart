import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2caretaker/Utils/screen_utils.dart';
import 'package:care2caretaker/Views_/Auth_screen/Sigin_screen/signIn_view.dart';
import 'package:care2caretaker/Views_/Document_Upload/document_uploadView.dart';
import 'package:care2caretaker/Views_/Profile/Controller/profileController.dart';
import 'package:care2caretaker/Views_/patient_history/patients_history.dart';
import 'package:care2caretaker/reuse_widgets/AppColors.dart';
import 'package:care2caretaker/reuse_widgets/appBar.dart';
import 'package:care2caretaker/reuse_widgets/customLabel.dart';
import 'package:care2caretaker/reuse_widgets/image_background.dart';
import 'package:care2caretaker/reuse_widgets/sizes.dart';
import 'package:care2caretaker/sharedPref/sharedPref.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../Notification/controller/controller.dart';
import '../Notifications/Notification_view.dart';
import 'Information_view.dart';

class ProfileDetails extends StatelessWidget {
  ProfileDetails({super.key});

  ProfileController controller = Get.put(ProfileController());
  NotificationController notifyController = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (v) {
      return CustomBackground(
        appBar: CustomAppBar(
          title: "Profile Details",
          actions: [
            GetBuilder<NotificationController>(builder: (v) {
              return Badge(
                offset: Offset(-5, 3),
                label: Text(v.unreadCount.toString()),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.to(() => NotificationView());
                  },
                  icon: const Icon(IconlyLight.notification),
                ),
              );
            }),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kHeight10,
                Container(
                  height: 65.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: CircleAvatar(
                          radius: 18.r, // The size of the CircleAvatar
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: '${v.profileList!.profilePath}${v.profileList!.data!.profileImage!}',
                              fit: BoxFit.cover,
                              width: 36.w,
                              height: 36.h,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              v.profileList!.data!=null && v.profileList!.data!.caretakerInfo!=null?Text(
                                '${v.profileList!.data!.caretakerInfo!.firstName!} ${v.profileList!.data!.caretakerInfo!.lastName!}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ) : SizedBox(),
                              SizedBox(height: 2.h),
                              Text(
                                "Am Care Taker",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                kHeight20,
                CustomLabel(text: "General"),
                kHeight5,
                ProfileDetailsCustom(
                  icons: IconlyBold.profile,
                  iconColor: Color(0xff246AFD),
                  heading: "Profile Information",
                  message: "change Your Account Information ",
                  callback: () {
                    Get.to(() => AccountInformation());
                  },
                ),
                Divider(),
                ProfileDetailsCustom(
                  icons: Icons.medical_information,
                  iconColor: Colors.red,
                  heading: "Patient History",
                  message: "View Your Patients",
                  callback: () {
                    Get.to(() => PatientsHistory());
                  },
                ),
                Divider(),
                ProfileDetailsCustom(
                  icons: Icons.picture_as_pdf,
                  iconColor: Colors.redAccent,
                  heading: "My Documents",
                  message: "Upload or view Documents",
                  callback: () {
                    Get.to(() => DocumentUploadNew());
                  },
                ),
                Divider(),
                ProfileDetailsCustom(
                  callback: () async {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.rightSlide,
                      title: 'Are You Sure ',
                      desc: ' Want to Logout',
                      btnCancelOnPress: () {
                        Get.back();
                      },
                      btnOkOnPress: () async {
                        await SharedPref().logout();
                      },
                    )..show();
                  },
                  icons: EneftyIcons.logout_bold,
                  iconColor: Color(0xff002574),
                  heading: "Logout",
                  message: "Click to Logout",
                ),
                Divider(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProfileDetailsCustom extends StatelessWidget {
  final String? heading;
  final String? message;
  final IconData? icons;
  final Color? circleColor;
  final Color? iconColor;
  VoidCallback? callback;
  double? radiusSize;

  ProfileDetailsCustom({
    super.key,
    this.heading,
    this.message,
    this.icons,
    this.callback,
    this.circleColor,
    this.iconColor,
    this.radiusSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.1),
              radius: radiusSize ?? 18.r,
              child: Icon(
                icons,
                color: iconColor,
                size: 20.sp,
              ),
            ),
          ),
          kWidth10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  heading ?? "Alis Dia",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  message ?? "sujnc901@gmail.com",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: callback,
            icon: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
