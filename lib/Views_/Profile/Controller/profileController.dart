import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../api_urls/url.dart';
import '../../../modals/profilr_info_modal.dart';
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
        "sex": sexController.text,
        "age": int.parse(ageController.text),
        "dob": dobController.text,
        "email": emailCT.text,
        "service_charge": costCT.text,
        "total_patients_attended": totalPatientsCT.text,
        "medical_license": medicalLicenseController.text,
        "location": locationController.text,
        "nationality": nationalityController.text,
        "address": addressController.text,
        "uploaded_documents": "sasasasasasasasasa",
        "year_of_experiences": yearOfExperienceController.text,
        "primary_contact_number": primaryContactController.text,
        "secondary_contact_number": secondaryContactController.text
      };

      var res = await http.post(
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
        Get.to(() => HomeView());
        debugPrint("Successfully Insert care Taker Details");
      } else {
        debugPrint("Not Successfully Insert care Taker Details");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    update();
  }

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
        "sex": sexController.text,
        "age": int.parse(ageController.text),
        "dob": dobController.text,
        "email": emailCT.text,
        "service_charge": costCT.text,
        "total_patients_attended": totalPatientsCT.text,
        "medical_license": medicalLicenseController.text,
        "location": locationController.text,
        "nationality": nationalityController.text,
        "address": addressController.text,
        "uploaded_documents": "sasasasasasasasasa",
        "year_of_experiences": yearOfExperienceController.text,
        "primary_contact_number": primaryContactController.text,
        "secondary_contact_number": secondaryContactController.text
      };

      var res = await http.put(
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
        debugPrint("Successfully update care Taker Details");
      } else {
        debugPrint("Not Successfully update care Taker Details");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    update();
  }

  bool fetchLoading = false;

  fetchCareTakerDetails() async {
    fetchLoading = true;
    update();

    try {
      var token = await SharedPref().getToken();
      var res = await http.get(
        Uri.parse(URls().careTakerInfo),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      if (res.statusCode == 200) {
        var decodeJson = jsonDecode(res.body);
        /*if (decodeJson['data'] != null) {*/
        profileList = ProfileList.fromJson(decodeJson);
        if (profileList!.data!.caretakerInfo != null) {
          profileInfo = profileList!.data!.caretakerInfo;
          firstNameController.text = profileInfo!.firstName ?? '';
          lastNameController.text = profileInfo!.lastName ?? '';
          sexController.text = profileInfo!.sex ?? '';
          emailCT.text = profileInfo!.email ?? '';
          costCT.text = profileInfo!.serviceCharge ?? "";
          totalPatientsCT.text = profileInfo!.totalPatientsAttended ?? '';
          dobController.text =
              DateFormat('yyyy-MM-dd').format(profileInfo!.dob!);
          locationController.text = profileInfo!.location ?? '';
          ageController.text = profileInfo!.age.toString();
          nationalityController.text = profileInfo!.nationality ?? '';
          medicalLicenseController.text = profileInfo!.medicalLicense ?? "";
          yearOfExperienceController.text =
              profileInfo!.yearOfExperiences ?? '';
          addressController.text = profileInfo!.address ?? '';
          primaryContactController.text =
              profileInfo!.primaryContactNumber ?? '';
          secondaryContactController.text =
              profileInfo!.secondaryContactNumber ?? '';
          update();
        }
        /* } else {
          debugPrint("Data is null or not in expected format");
        }*/
      } else {
        debugPrint("Error fetching data: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }
    fetchLoading = false;
    update();
  }

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
      String fileName = path.basename(selectImage!.path);
      var req =
          await http.MultipartRequest('POST', Uri.parse(URls().uploadImage));
      req.files.add(await http.MultipartFile.fromPath(
          'profile_image_url', selectImage!.path,
          filename: fileName));
      req.fields['id'] = patientId!;
      req.headers['Content-Type'] = 'multipart/form-data';
      if (token != null) {
        req.headers['Authorization'] = 'Bearer $token';
      }
      var response = await req.send();
      update();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final Map<String, dynamic> jsonResponse = jsonDecode(responseString);
        String newImageUrl = jsonResponse['image'];
        profileList!.data!.profileImage = newImageUrl;
        update();
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
    uploadLoading = false;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchCareTakerDetails();
    super.onInit();
  }
}
