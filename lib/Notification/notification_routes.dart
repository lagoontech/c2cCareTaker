/// FCM `data` payload keys the backend should send alongside the notification.
///
/// Example push data:
/// ```json
/// {
///   "screen": "patient_requests",
///   "appointment_id": "123"
/// }
/// ```
class NotificationRoutes {
  NotificationRoutes._();

  static const patientRequests = 'patient_requests';
  static const appointmentsApproved = 'appointments_approved';
  static const appointmentsProcessing = 'appointments_processing';
  static const notificationList = 'notification_screen';

  /// Bottom nav index for [PatientrequestView].
  static const patientRequestsTabIndex = 1;
  static const appointmentsTabIndex = 2;

  /// Top tab index inside AppointmentStatusView.
  static const approvedSubTabIndex = 0;
  static const processingSubTabIndex = 1;
}
