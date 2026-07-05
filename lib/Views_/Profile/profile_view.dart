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

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController PC = Get.put(ProfileController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _requiredValidator(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Email');
    if (requiredError != null) return requiredError;
    final text = value!.trim();
    final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailReg.hasMatch(text)) return 'Enter a valid email';
    return null;
  }

  String? _dobValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Date of Birth');
    if (requiredError != null) return requiredError;
    final text = value!.trim();
    final dobReg = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dobReg.hasMatch(text)) return 'Use YYYY-MM-DD format';
    return null;
  }

  String? _ageValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Age');
    if (requiredError != null) return requiredError;
    final age = int.tryParse(value!.trim());
    if (age == null) return 'Age must be a number';
    if (age < 0 || age > 150) return 'Age must be between 0 and 150';
    return null;
  }

  String? _serviceChargeValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Service Charge');
    if (requiredError != null) return requiredError;
    final amount = double.tryParse(value!.trim());
    if (amount == null) return 'Service charge must be numeric';
    if (amount < 0) return 'Service charge must be positive';
    return null;
  }

  String? _primaryContactValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Primary Contact Number');
    if (requiredError != null) return requiredError;
    final cleaned = value!.trim();
    final reg = RegExp(r'^[0-9+\-\s()]{7,15}$');
    if (!reg.hasMatch(cleaned)) {
      return 'Primary Contact Number is invalid';
    }
    return null;
  }

  bool _validateBeforeSubmit(ProfileController v) {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) return false;
    if (v.sexController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Sex is required');
      return false;
    }
    return true;
  }

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
                              if (!_validateBeforeSubmit(v)) return;
                              v.insertCaretakerProfileDetails();
                              v.update();
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
                  child: Form(
                    key: _formKey,
                    child: GetBuilder<ProfileController>(builder: (v) {
                      return Column(
                        children: [
                          SizedBox(height: 5.h),
                          GetBuilder<ProfileController>(builder: (o) {
                            return customTextField(context,
                                labelText: "First Name *",
                                controller: o.firstNameController,
                                validator: (value) =>
                                    _requiredValidator(value, 'First Name'));
                          }),
                          SizedBox(height: 15.h),
                          customTextField(context,
                              labelText: "Last Name *",
                              controller: v.lastNameController,
                              validator: (value) =>
                                  _requiredValidator(value, 'Last Name')),
                          SizedBox(height: 15.h),
                          customTextField(context,
                              labelText: "E-mail *",
                              controller: v.emailCT,
                              textInputType: TextInputType.emailAddress,
                              validator: _emailValidator),
                          SizedBox(height: 15.h),
                          GetBuilder<ProfileController>(builder: (v) {
                            return customTextField(
                              context,
                            readOnly: true,
                            onTap: () {
                              v.selectDob(context);
                            },
                              suffix: IconButton(
                                  onPressed: () {
                                    v.selectDob(context);
                                  },
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.primaryColor,
                                  )),
                              controller: v.dobController,
                              labelText: "Date of Birth *",
                              validator: _dobValidator,
                            );
                          }),
                          kHeight20,
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: customDropdown(context,
                                      value: ["Male", "Female", "Other"]
                                              .contains(v.sexController.text)
                                          ? v.sexController.text
                                          : null,
                                      items: ["Male", "Female", "Other"]
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      labelText: "Sex *", onChanged: (val) {
                                    v.sexController.text = val;
                                    print(v.sexController.text);
                                  })),
                              kWidth20,
                              Flexible(
                                flex: 5,
                                child: customTextField(context,
                                    readOnly: true,
                                    labelText: "Age *",
                                    controller: v.ageController,
                                    validator: _ageValidator),
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
                            labelText: "Medical License *",
                            validator: (value) =>
                                _requiredValidator(value, 'Medical License'),
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
                            labelText: "Address *",
                            validator: (value) =>
                                _requiredValidator(value, 'Address'),
                          ),
                          kHeight20,
                          customTextField(
                            context,
                            controller: v.costCT,
                            labelText: "Service Charge *",
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            validator: _serviceChargeValidator,
                          ),
                          kHeight20,
                          customTextField(
                            context,
                            controller: v.totalPatientsCT,
                            labelText: "Total Patients Attended *",
                          ),
                          kHeight20,
                          customTextField(
                            context,
                            textInputType: TextInputType.phone,
                            controller: v.primaryContactController,
                            labelText: "Primary Contact Number *",
                            validator: _primaryContactValidator,
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
