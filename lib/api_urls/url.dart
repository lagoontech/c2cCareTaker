class URls {
  static String baseUrl = 'https://care2carevital.us';

  String loginorsignup = '$baseUrl/api/caretaker/login-or-register';

  String checkOtp = '$baseUrl/api/caretaker/verify-otp';

  String profileDetailsInsert = '$baseUrl/api/caretaker/caretaker-info/add';

  String profileDetailsEdit = '$baseUrl/api/caretaker/caretaker-info/edit';

  String careTakerInfo = '$baseUrl/api/caretaker/caretaker/view';

  String viewAllCareTakers = '$baseUrl/api/caretaker/caretaker/viewall';

  String uploadImage = '$baseUrl/api/caretaker/caretaker/profile-img-upload';

  String uploadDoc  = '$baseUrl/api/caretaker/caretaker/documents-upload';

  String delDoc = '$baseUrl/api/caretaker/caretaker-info/delete';

  String individualPatient = '$baseUrl/api/caretaker/caretaker/view-patient';

  String viewRequests = '$baseUrl/api/caretaker/caretaker/appointment-requests';

  String acceptPatientRequest = '$baseUrl/api/caretaker/caretaker/approve-appointment';

  String rejectPatientRequest = '$baseUrl/api/caretaker/caretaker/reject-appointment';

  String loadRejectList = '$baseUrl/api/caretaker/caretaker/cancelled-appointments';

  String UpdateFCMToken = '$baseUrl/api/caretaker/update-token';

  String allNotifications = '$baseUrl/api/caretaker/caretaker/notifications';

  String markAllUnread =  '$baseUrl/api/caretaker/caretaker/notifications/mark-all-as-read';

  String serviceHistory = '$baseUrl/api/caretaker/caretaker/create-service-history';

  String ServiceHistory = '$baseUrl/api/caretaker/caretaker/get-service-history';


}
