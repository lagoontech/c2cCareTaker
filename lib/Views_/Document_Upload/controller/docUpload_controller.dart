import 'dart:convert';

import 'dart:io';
import 'package:care2caretaker/api_urls/url.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../modals/profilr_info_modal.dart';
import '../../../sharedPref/sharedPref.dart';

class DocsUploadController extends GetxController {
  @override
  void onInit() {
    fetchDocumentApi();
    // TODO: implement onInit
    super.onInit();
  }

  bool uploading = false;
  bool isFetchDoc = false;
  List<File> selectedFiles = [];
  List<CaretakerDocument> uploadedDocuments = [];
  ProfileList? profileList;
  bool showUploadField =false;



  TextEditingController inputFileNameCT = TextEditingController();

  void toggleUploadField() {
    showUploadField = !showUploadField;
    update();
  }

  Future<void> pickDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf', /*'doc', 'docx', 'jpg', 'png'*/
      ],
    );
    if (result != null) {
      selectedFiles = result.paths.map((path) => File(path!)).toList();

      for (var file in selectedFiles) {
        uploadedDocuments.add(CaretakerDocument(
            fileName: file.path.split('/').last,
            filePath: file.path,
            createdAt: DateTime.now().toIso8601String()));
      }
      await multiDocUploadApi();
      update();
    } else {
      Get.snackbar('Error', 'No files selected');
    }
  }

  multiDocUploadApi() async {
    // Check if there are files to upload
    if (selectedFiles.isEmpty) {
      Get.snackbar('Error', 'No files selected for upload');
      return;
    }

    uploading = true; // Set uploading state
    update(); // Update the UI

    var id = await SharedPref().getId(); // Get patient ID
    var token = await SharedPref().getToken(); // Get authorization token
    var request = http.MultipartRequest('POST', Uri.parse(URls().uploadDoc));

    // Add files to the request
    for (var file in selectedFiles) {
      request.files.add(await http.MultipartFile.fromPath('document', file.path));
    }

    // Set headers for the request
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });
    request.fields['patient_id'] = id!;
    request.fields['document_name'] = inputFileNameCT.text;

    // Send the request
    var res = await request.send();
    var response = await http.Response.fromStream(res);

    // Check for successful response
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print("PDF response: $responseData");

      // Ensure the 'data' field contains 'patient_documents'
      if (responseData['data'] != null && responseData['data']['patient_documents'] != null) {
        List<dynamic> uploadedDocsJson = responseData['data']['patient_documents'];
        for (var docJson in uploadedDocsJson) {
          uploadedDocuments.add(CaretakerDocument.fromJson(docJson)); // Add to the list
          print(docJson); // Log for debugging
        }
      } else {
        //  Get.snackbar('Error', 'No document data returned');
      }

      inputFileNameCT.clear(); // Clear the input field
      showUploadField = false; // Hide upload field
      await fetchDocumentApi(); // Fetch updated documents
      update(); // Update the UI
      Get.snackbar('Success', 'Documents uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to upload documents',
          snackPosition: SnackPosition.BOTTOM);
    }

    uploading = false; // Reset uploading state
    update(); // Final UI update
  }

  fetchDocumentApi() async {
    String? token = await SharedPref().getToken();
    isFetchDoc =true;
    update();

    try {
      var res = await http.get(
        Uri.parse(URls().careTakerInfo),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        profileList = profileListFromJson(res.body);
        if (profileList != null) {
          uploadedDocuments = profileList!.data!.caretakerDocuments!;
          update();
        }
      }
    } catch (e) {
      print('error $e');
    }
    isFetchDoc =false;
    update();
  }

  bool isDeleting = false;

  deleteDocumentApi(int? index) async {
    var docDel = uploadedDocuments[index!];
    docDel.isDeletingDoc = true;
    update();
    try {
      var docIdToDelete = uploadedDocuments[index].id;
      var id = await SharedPref().getId();
      var token = await SharedPref().getToken();
      var req =
      await http.delete(Uri.parse(URls().delDoc), headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'id': docIdToDelete.toString(),
        'patient_id': id.toString()
      });
      if (req.statusCode == 200) {
        print("delete index$index");
        await Future.delayed(Duration(seconds: 2));
        uploadedDocuments.removeAt(index);
      } else {
        print("cant delete");
      }
    } catch (e) {
      print("error delete Api $e");
    }
    docDel.isDeletingDoc = false;
    update();
  }


}

class CaretakerDocument {
  int? id;
  int? patientId;
  String? fileName;
  String? documentName;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  bool?isDeletingDoc;

  CaretakerDocument({
    this.id,
    this.patientId,
    this.fileName,
    this.filePath,
    this.documentName,
    this.createdAt,
    this.updatedAt,
    this.isDeletingDoc = false,
  });

  factory CaretakerDocument.fromJson(Map<String, dynamic> json) =>
      CaretakerDocument(
        id: json["id"],
        patientId: json["patient_id"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        documentName: json["document_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "file_name": fileName,
    "document_name": documentName,
    "file_path": filePath,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

