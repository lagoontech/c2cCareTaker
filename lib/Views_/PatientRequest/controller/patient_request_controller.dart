import 'dart:convert';
import 'package:care2caretaker/api_urls/url.dart';
import 'package:care2caretaker/reuse_widgets/customToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/date_utils.dart';
import '../../../sharedPref/sharedPref.dart';
import '../../Appointments/appointmentStaus_view.dart';
import '../modal/getService_history.dart';
import '../modal/patientRequest_modal.dart';

class PatientRequestController extends GetxController {
  List<Datum> caretakersList = [];
  CareTakersList? careTakersListResponse;
  bool isLoading = false;
  List<Datum> approvedList = [];
  List<Datum> searchedApprovedList = [];
  List<Datum> rejectedList = [];
  List<Datum> searchedRejectedList = [];
  List<Datum> requestList = [];
  List<Datum> processingList = [];
  List<Datum> searchedProcessingList = [];
  List<Datum> completedList = [];
  List<Datum> searchedCompletedList = [];

  DateTime ?selectedDate;

  int currentTab = 0;
  TextEditingController searchTEC = TextEditingController();
  String ?displayDate;

  loadRequests() async {
    String? token = await SharedPref().getToken();
    if (token == null) {
      print('Token not found');
      return;
    }
    isLoading = true;
    update();

    try {
      var res = await http.get(
        Uri.parse(URls().viewRequests),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        careTakersListResponse = careTakersListFromJson(res.body);
        caretakersList.assignAll(careTakersListResponse!.data ?? []);
        approvedList.assignAll(caretakersList
            .where((item) => item.serviceStatus == 'approved')
            .toList());
        /*   rejectedList.assignAll(caretakersList
            .where((item) =>
                item.serviceStatus == 'rejected' ||
                item.serviceStatus == 'cancelled')
            .toList());*/
        requestList.assignAll(caretakersList
            .where((item) => item.serviceStatus == 'requested')
            .toList());
        processingList.assignAll(caretakersList
            .where((item) => item.serviceStatus == 'processing')
            .toList());
        completedList.assignAll(caretakersList
            .where((item) => item.serviceStatus == 'completed')
            .toList());
        update();
      } else {
        print(
            "Failed to fetch caretakers data. Status Code: ${res.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
    }
    isLoading = false;
    update();
  }

  bool isRejecting = false;
  bool isAccepting = false;

  acceptRequestApi({
    int? appointmentId,
    int? patientId,
  }) async {
    isAccepting = true;
    update();

    try {
      String? token = await SharedPref().getToken();
      final Map<String, dynamic> bodyData = {
        "appointment_id": appointmentId,
        "patient_id": patientId,
      };
      var res = await http.post(
        Uri.parse(URls().acceptPatientRequest),
        body: jsonEncode(bodyData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);
        showCustomToast(message: "Successfully Accepted");
        Get.back();
        Get.to(() => AppointmentStatusView());
      } else {
        debugPrint('Error: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    isAccepting = false;
    update();
  }

  rejectRequestApi({
    int? appointmentId,
    int? patientId,
  }) async {
    isRejecting = true;
    update();

    try {
      String? token = await SharedPref().getToken();
      final Map<String, dynamic> bodyData = {
        "appointment_id": appointmentId,
        "patient_id": patientId,
      };
      var res = await http.post(
        Uri.parse(URls().rejectPatientRequest),
        body: jsonEncode(bodyData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);
        showCustomToast(message: "Successfully Rejected");
        Get.back();
        Get.to(() => AppointmentStatusView());
      } else {
        debugPrint('Error: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    isRejecting = false;
    update();
  }

  loadRejectList() async {
    try {
      String? token = await SharedPref().getToken();
      var req = await http.get(
        Uri.parse(URls().loadRejectList),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (req.statusCode == 200) {
        careTakersListResponse = careTakersListFromJson(req.body);
        rejectedList = careTakersListResponse!.data ?? [];
        update();
      } else {
        debugPrint("Not load cancel req");
      }
    } catch (e) {
      print(e);
    }
  }

  ServiceHistory? serviceHistory;

  loadGetHistory({int? appointmentId, int? patientId}) async {
    try {
      String? token = await SharedPref().getToken();
      final uri = Uri.parse(URls().ServiceHistory).replace(queryParameters: {
        "appointment_id": appointmentId?.toString(),
        "patient_id": patientId?.toString(),
      });

      var res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        serviceHistory = ServiceHistory.fromJson(data);
      } else {
        print('Failed to load history: ${res.statusCode}');
      }
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  Future<void> launchDialer(String phoneNumber) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    print(phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  //
  //
  searchAppointments({bool completedOnly = false}){

    if(completedOnly){
      searchedCompletedList = completedList.where((app)
      {
        var hasAppointment = false;
        if(displayDate==null)
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }
      ).toList();
      update();
      return;
    }

    print("searching appointments... in tab-->$currentTab");
    if(currentTab == 0){
      searchedApprovedList = approvedList.where((app)
      {
        var hasAppointment = false;
        if(displayDate==null)
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }
      ).toList();
    }
    if(currentTab == 1){
      searchedProcessingList = processingList.where((app) {
        var hasAppointment = false;
        if(displayDate==null)
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }
      ).toList();
    }
    if(currentTab == 2){
      searchedRejectedList = rejectedList.where((app)
      {
        var hasAppointment = false;
        print(displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!));
        if(displayDate==null)
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.patient!.patientInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }).toList();
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    loadRequests();
    loadRejectList();
    super.onInit();
  }
}

//

/*{
"success": true,
"status": 200,
"type": "success",
"data": {
"id": 1,
"patient_id": 3,
"caretaker_id": 1,
"appointment_date": "2024-10-25",
"appointment_start_time": "14:00:00",
"appointment_end_time": "15:00:00",
"service_status": "rejected",
"payment_status": "pending",
"created_at": "2024-10-21T08:30:53.000000Z",
"updated_at": "2024-10-22T15:49:42.000000Z"
}
}*/
