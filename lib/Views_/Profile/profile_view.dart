import 'package:care2caretaker/Views_/Profile/Controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

import '../../reuse_widgets/AppColors.dart';
import '../../reuse_widgets/appBar.dart';
import '../../reuse_widgets/custom_textfield.dart';
import '../../reuse_widgets/image_background.dart';
import '../../reuse_widgets/sizes.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController PC = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (v) {
      return v.fetchLoading
          ? InitialProfileSkeleton()
          : CustomBackground(
              appBar: CustomAppBar(title: "Profile", actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: GetBuilder<ProfileController>(builder: (v) {
                    return v.isLoading
                        ? Center(
                            child: SizedBox(
                              height: 20.h,
                              width: 23.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              if (v.profileInfo == null) {
                                debugPrint("insertMethod");
                                v.insertCaretakerProfileDetails();
                              } else {
                                debugPrint("updateMethod");
                                v.updateCaretakerProfileDetails();
                              }
                            },
                            child: Icon(
                              IconlyLight.tick_square,
                              color: AppColors.primaryColor,
                            ),
                          );
                  }),
                ),
              ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                child: SingleChildScrollView(
                  child: GetBuilder<ProfileController>(builder: (v) {
                    return Column(
                      children: [
                        SizedBox(height: 5.h),
                        GetBuilder<ProfileController>(builder: (o) {
                          return customTextField(context,
                              labelText: "First Name",
                              controller: o.firstNameController);
                        }),
                        SizedBox(height: 15.h),
                        customTextField(context,
                            labelText: "Last Name",
                            controller: v.lastNameController),
                        SizedBox(height: 15.h),
                        customTextField(context,
                            labelText: "E-mail", controller: v.emailCT),
                        SizedBox(height: 15.h),
                        GetBuilder<ProfileController>(builder: (v) {
                          return customTextField(
                            context,
                            suffix: IconButton(
                                onPressed: () {
                                  v.selectDob(context);
                                },
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.primaryColor,
                                )),
                            controller: v.dobController,
                            labelText: "Date of Birth",
                          );
                        }),
                        kHeight20,
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: customTextField(context,
                                    labelText: "Sex",
                                    controller: v.sexController)),
                            kWidth20,
                            Flexible(
                              flex: 5,
                              child: customTextField(context,
                                  readOnly: true,
                                  labelText: "Age",
                                  controller: v.ageController),
                            ),
                          ],
                        ),
                        kHeight20,
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: customTextField(context,
                                    controller: v.locationController,
                                    labelText: "Location")),
                            kWidth15,
                            Flexible(child:
                                GetBuilder<ProfileController>(builder: (v) {
                              return GestureDetector(
                                onTap: () {
                                  v.getCurrentLocation();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  color: AppColors.primaryColor,
                                  child: v.isLocation
                                      ? Center(
                                          child: SizedBox(
                                            height: 20.h,
                                            width: 23.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 0.7,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.add_location_alt,
                                          color: Colors.white,
                                        ),
                                ),
                              );
                            })),
                          ],
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: v.nationalityController,
                          labelText: "Nationality",
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: v.medicalLicenseController,
                          labelText: "Medical License",
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: v.yearOfExperienceController,
                          labelText: "Experience",
                        ),

                        //document upload

                        /*   kHeight20,
                      DottedBorder(
                          color: Colors.grey,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                kHeight5,
                                CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  radius: 22,
                                  child: Icon(
                                    EneftyIcons.document_upload_outline,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      // Get.to(() => AddressView());
                                    },
                                    child: Text(
                                      "Click to upload",
                                      style:
                                          TextStyle(color: AppColors.primaryColor),
                                    )),
                                Text("Max File size")
                              ],
                            ),
                          )),*/
                        kHeight20,
                        customTextField(
                          context,
                          maxLines: 3,
                          controller: v.addressController,
                          labelText: "Address",
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: v.costCT,
                          labelText: "My Cost",
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: TextEditingController(
                              text: '${v.totalPatientsCT.text}+Patients'),
                          labelText: "Total Patients Attended",
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: v.primaryContactController,
                          labelText: "Primary Contact Number",
                        ),
                        kHeight20,
                        customTextField(
                          context,
                          controller: v.secondaryContactController,
                          labelText: "Secondary Contact",
                        ),
                        kHeight20,
                      ],
                    );
                  }),
                ),
              ));
    });
  }
}

//Loader

class InitialProfileSkeleton extends StatelessWidget {
  const InitialProfileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: List.generate(
            10,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
