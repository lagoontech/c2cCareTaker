import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../api_urls/url.dart';
import '../../../modals/profilr_info_modal.dart';
import '../../../Utils/http_service.dart';
import '../../../reuse_widgets/customToast.dart';
import '../../../sharedPref/sharedPref.dart';
import '../../HomeView/home_view.dart';
import 'package:path/path.dart' as path;

class ProfileController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailCT = TextEditingController();
  TextEditingController medicalLicenseController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController costCT = TextEditingController();
  TextEditingController totalPatientsCT = TextEditingController();
  TextEditingController yearOfExperienceController = TextEditingController();
  TextEditingController primaryContactController = TextEditingController();
  TextEditingController secondaryContactController = TextEditingController();

  DateTime? dob;
  bool isLoading = false;
  bool isLocation = false;
  CaretakerInfo? profileInfo;
  ProfileList? profileList;

  String _extractValidationError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final errors = decoded['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
          if (first != null) return first.toString();
        }

        if (decoded['message'] != null) {
          return decoded['message'].toString();
        }

        for (final value in decoded.values) {
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
        }
      }
    } catch (_) {}
    return 'Please check the highlighted fields and try again.';
  }

  //
  Future<void> selectDob(BuildContext context) async {
    DateTime? pickDob = await showDatePicker(
        context: context,
        initialDate: dob ?? DateTime.now(),
        firstDate: DateTime(1000),
        lastDate: DateTime(2101));
    if (pickDob != null && pickDob != dob) {
      dob = pickDob;
      dobController.text = DateFormat('yyyy-MM-dd').format(dob!);
      int age = calculateAge(dob!);
      ageController.text = age.toString();
      update();
    }
  }

  // calculate age when select the dob
  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  //indicate details fill Completed
  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }

  //

  //
  insertCaretakerProfileDetails() async {
    isLoading = true;
    update();
    try {
      var careTakerId = await SharedPref().getId();
      var token = await SharedPref().getToken();
      Map<String, dynamic> caretakerData = {
        "caretaker_id": int.parse(careTakerId!),
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "sex": sexController.text.toLowerCase(),
        "age": int.parse(ageController.text),
        "dob": dobController.text,
        "email": emailCT.text,
        "service_charge": costCT.text,
        "total_patients_attended": totalPatientsCT.text,
        "medical_license": medicalLicenseController.text,
        "location": locationController.text,
        "nationality": nationalityController.text,
        "address": addressController.text,
        "uploaded_documents": profileInfo?.uploadedDocuments ?? '',
        "year_of_experiences": yearOfExperienceController.text,
        "primary_contact_number": primaryContactController.text,
        "secondary_contact_number": secondaryContactController.text
      };

      var res = await HttpService.instance.post(
        Uri.parse(URls().profileDetailsInsert),
        body: jsonEncode(caretakerData),
        headers: {
          "Content-Type": "application/json",
          "Accept": 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        onUserDetailsCompleted();
        try{
          await Get.delete<ProfileController>();
        }catch(e){
          print(e);
        }
        Get.to(() => HomeView());
        debugPrint("Successfully Insert care Taker Details");
      } else {
        final error = _extractValidationError(res.body);
        showCustomToast(message: error);
        debugPrint("Not Successfully Insert care Taker Details");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    update();
  }

  //
  updateCaretakerProfileDetails() async {
    isLoading = true;
    update();

    try {
      var careTakerId = await SharedPref().getId();
      var token = await SharedPref().getToken();
      Map<String, dynamic> caretakerData = {
        "caretaker_id": int.parse(careTakerId!),
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "sex": sexController.text.toLowerCase(),
        "age": int.parse(ageController.text),
        "dob": dobController.text,
        "email": emailCT.text,
        "service_charge": costCT.text,
        "total_patients_attended": totalPatientsCT.text,
        "medical_license": medicalLicenseController.text,
        "location": locationController.text,
        "nationality": nationalityController.text,
        "address": addressController.text,
        "uploaded_documents": profileInfo?.uploadedDocuments ?? '',
        "year_of_experiences": yearOfExperienceController.text,
        "primary_contact_number": primaryContactController.text,
        "secondary_contact_number": secondaryContactController.text
      };

      var res = await HttpService.instance.put(
        Uri.parse(URls().profileDetailsEdit),
        body: jsonEncode(caretakerData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        onUserDetailsCompleted();
        Get.to(() => HomeView());
        showCustomToast(
            message: "Profile updated successfully",
            backgroundColor: Colors.green
        );
        update();
      } else {
        final error = _extractValidationError(res.body);
        showCustomToast(message: error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    update();
  }

  bool fetchLoading = false;
  int _fetchGeneration = 0;

  static const _sexOptions = ['Male', 'Female', 'Other'];

  String? _normalizeSex(String? sex) {
    if (sex == null || sex.trim().isEmpty) return null;
    final normalized = sex.trim().toLowerCase();
    for (final option in _sexOptions) {
      if (option.toLowerCase() == normalized) return option;
    }
    return null;
  }

  void _clearFormFields() {
    firstNameController.clear();
    lastNameController.clear();
    sexController.clear();
    ageController.clear();
    dobController.clear();
    emailCT.clear();
    medicalLicenseController.clear();
    locationController.clear();
    nationalityController.clear();
    addressController.clear();
    costCT.clear();
    totalPatientsCT.clear();
    yearOfExperienceController.clear();
    primaryContactController.clear();
    secondaryContactController.clear();
    dob = null;
  }

  void _applyCaretakerInfoToForm(CaretakerInfo? info) {
    _clearFormFields();
    profileInfo = info;
    if (info == null) return;

    firstNameController.text = info.firstName ?? '';
    lastNameController.text = info.lastName ?? '';
    sexController.text = _normalizeSex(info.sex) ?? '';
    emailCT.text = info.email ?? '';
    costCT.text = info.serviceCharge ?? '';
    totalPatientsCT.text = info.totalPatientsAttended ?? '';
    dob = info.dob;
    dobController.text =
        info.dob != null ? DateFormat('yyyy-MM-dd').format(info.dob!) : '';
    locationController.text = info.location ?? '';
    ageController.text = info.age?.toString() ?? '';
    nationalityController.text = info.nationality ?? '';
    medicalLicenseController.text = info.medicalLicense ?? '';
    yearOfExperienceController.text = info.yearOfExperiences ?? '';
    addressController.text = info.address ?? '';
    primaryContactController.text = info.primaryContactNumber ?? '';
    secondaryContactController.text = info.secondaryContactNumber ?? '';
  }

  //
  fetchCareTakerDetails() async {
    final generation = ++_fetchGeneration;
    fetchLoading = true;
    _clearFormFields();
    update();

    try {
      var token = await SharedPref().getToken();
      var res = await HttpService.instance.get(
        Uri.parse(URls().careTakerInfo),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      if (generation != _fetchGeneration) return;

      if (res.statusCode == 200 && res.body.trim().isNotEmpty) {
        final decodeJson = jsonDecode(res.body);
        if (decodeJson is Map<String, dynamic>) {
          profileList = ProfileList.fromJson(decodeJson);
          _applyCaretakerInfoToForm(profileList?.data?.caretakerInfo);
        } else {
          profileList = null;
          profileInfo = null;
          _clearFormFields();
        }
      } else {
        profileList = null;
        profileInfo = null;
        _clearFormFields();
        debugPrint("Error fetching data: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      if (generation != _fetchGeneration) return;
      profileList = null;
      profileInfo = null;
      _clearFormFields();
      debugPrint("Exception: ${e.toString()}");
    }

    if (generation != _fetchGeneration) return;
    fetchLoading = false;
    update();
  }

  //
  Future<void> getCurrentLocation() async {
    isLocation = true;
    update();
    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        showCustomToast(message: "Please Enable location");
        isLocation = false;
        update();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showCustomToast(message: 'Location permission denied.');
          isLocation = false;
          update();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showCustomToast(message: "Location permissions are permanently denied");
        isLocation = false;
        update();
      }
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      locationController.text = address;
      update();
      showCustomToast(message: 'Location updated successfully!');
    } catch (e) {
      print(e);
    }
    isLocation = false;
    update();
  }

  // profileImageUpload Process

  File? selectImage;
  ImagePicker imagePicker = ImagePicker();
  bool uploadLoading = false;

  //
  pickImage(ImageSource imageSource, BuildContext context) async {
    XFile? image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      selectImage = File(image.path);
      update();
      debugPrint("Image selected: ${selectImage?.path}");
      await profileImageUpload();
      update();
    }
    Navigator.pop(context);
  }

  //
  profileImageUpload() async {
    if (selectImage == null) {
      debugPrint("No image selected for upload");
      return;
    }
    uploadLoading = true;
    update();
    try {
      String? patientId = await SharedPref().getId();
      String? token = await SharedPref().getToken();
      if (patientId == null || selectImage == null) {
        debugPrint("Missing patient id or image for upload");
        uploadLoading = false;
        update();
        return;
      }
      String fileName = path.basename(selectImage!.path);
      var req =
          http.MultipartRequest('POST', Uri.parse(URls().uploadImage));
      req.files.add(await http.MultipartFile.fromPath(
          'profile_image_url', selectImage!.path,
          filename: fileName));
      req.fields['id'] = patientId;
      req.headers['Content-Type'] = 'multipart/form-data';
      if (token != null) {
        req.headers['Authorization'] = 'Bearer $token';
      }
      var response = await HttpService.instance.sendMultipart(req);
      update();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final Map<String, dynamic> jsonResponse = jsonDecode(responseString);
        String newImageUrl = jsonResponse['image'];
        profileList?.data?.profileImage = newImageUrl;
        update();
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
    uploadLoading = false;
    update();
  }

  deleteProfileImage() async {
    try {
      String? token = await SharedPref().getToken();
      var res = await HttpService.instance.post(
        Uri.parse(URls().deleteProfileImage),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      if(res.statusCode ==200 ){
        selectImage = null;
        profileList?.data?.profileImage = 'default-profile-img-female.png';
        update();
        showCustomToast(message: 'Successfully Removed');
      }else{
        showCustomToast(message: 'Not Successfully Removed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    fetchCareTakerDetails();
    super.onInit();
  }
}
