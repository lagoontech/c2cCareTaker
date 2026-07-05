/*

import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Views_/Auth_screen/Sigin_screen/controller/login_controller.dart';
import '../sharedPref/sharedPref.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // String? fcmToken;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    initFirebaseMessaging();
    initLocalNotifications();
  }

  // Initialize Firebase Messaging
  void initFirebaseMessaging() async {
    */
/*fcmToken = await messaging.getToken();
    print('FCM Token: $fcmToken');*/ /*

   // LoginController().getFcmToken();

    var  fcmTokens = await SharedPref().getFCMToken();
    print("after close $fcmTokens");
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.notification?.body}');

      // Show local notification
      if (message.notification != null) {
        showLocalNotification(
          message.notification?.title,
          message.notification?.body,
        );
      }
    });

    // Handle when the app is opened via the notification (from background or terminated state)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.notification?.body}');
    });
  }

  // Initialize Local Notifications Plugin
  void initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a local notification
  void showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id', // ID for the notification channel
      'channel_name', // Name of the notification channel
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title ?? 'Default Title', // Notification Title
      body ?? 'Default Body', // Notification Body
      platformChannelSpecifics, // Notification Details
    );
  }
}
*/
import 'package:care2caretaker/Views_/HomeView/Controller/bottomNav_controller.dart';
import 'package:care2caretaker/Views_/PatientRequest/controller/patient_request_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../api_urls/url.dart';
import '../../reuse_widgets/customToast.dart';
import '../../Utils/http_service.dart';
import '../../sharedPref/sharedPref.dart';
import '../modal/Notification_modal.dart';
import '../notification_routes.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var unreadCount = 0;

  /// Survives controller re-registration; used for cold-start notification taps.
  static Map<String, dynamic>? _launchPayload;

  /// Holds tap payload until [HomeView] is mounted (cold start / splash).
  Map<String, dynamic>? _pendingNotificationData;

  @override
  void onInit() {
    super.onInit();
    initFirebaseMessaging();
    initLocalNotifications();
    setupInteractedMessage();
    allNotifications();
  }

  /// Call from [HomeView] once the shell (bottom nav) is ready.
  void markAppReady() {
    _pendingNotificationData ??= _launchPayload;
    _launchPayload = null;
    _flushPendingNavigation();
  }

  void clearPendingNavigation() {
    _pendingNotificationData = null;
    _launchPayload = null;
  }

  void _flushPendingNavigation() {
    final pending = _pendingNotificationData ?? _launchPayload;
    _pendingNotificationData = null;
    _launchPayload = null;
    if (pending == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyNavigation(pending);
    });
  }

  /// Single entry point for all notification taps (FCM + local).
  void handleNotificationOpen(Map<String, dynamic> data) {
    if (kDebugMode) {
      debugPrint(
        'handleNotificationOpen → data: $data, canNavigateNow: ${_canNavigateNow()}',
      );
    }
    if (_canNavigateNow()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyNavigation(data);
      });
    } else {
      final copy = Map<String, dynamic>.from(data);
      _pendingNotificationData = copy;
      _launchPayload = copy;
    }
  }

  bool _canNavigateNow() => Get.isRegistered<BottomNavController>();

  Map<String, dynamic> _routingDataFrom(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    final notification = message.notification;
    if (notification?.title != null) {
      data['_title'] = notification!.title!;
    }
    if (notification?.body != null) {
      data['_body'] = notification!.body!;
    }
    return data;
  }

  bool _isAppointmentRequest(Map<String, dynamic> data) {
    final type = (data['type'] ??
            data['notification_type'] ??
            data['event'] ??
            '')
        .toString()
        .toLowerCase();
    if (type.contains('appointment') && type.contains('request')) {
      return true;
    }
    if (type == 'appointment_request' ||
        type == 'new_appointment' ||
        type == 'patient_request' ||
        type == 'request_from_patient') {
      return true;
    }

    final title =
        (data['_title'] ?? data['title'] ?? '').toString().toLowerCase();
    final body =
        (data['_body'] ?? data['body'] ?? '').toString().toLowerCase();
    final text = '$title $body';
    return text.contains('appointment request') ||
        text.contains('new request from') ||
        text.contains('request from');
  }

  bool _isPaymentProcessingUpdate(Map<String, dynamic> data) {
    final type = (data['type'] ??
            data['notification_type'] ??
            data['event'] ??
            '')
        .toString()
        .toLowerCase();
    if (type.contains('payment') || type.contains('paid')) {
      return true;
    }
    if (type == 'appointment_paid' ||
        type == 'payment_received' ||
        type == 'appointment_processing') {
      return true;
    }

    final title =
        (data['_title'] ?? data['title'] ?? '').toString().toLowerCase();
    final body =
        (data['_body'] ?? data['body'] ?? '').toString().toLowerCase();
    final text = '$title $body';

    final mentionsPayment =
        text.contains('paid') || text.contains('payment received');
    final mentionsAppointment =
        text.contains('appointment') || text.contains('accepted request');
    return mentionsPayment && mentionsAppointment;
  }

  bool isPaymentNotificationText(String? title, String? body) {
    return _isPaymentProcessingUpdate({
      if (title != null) '_title': title,
      if (body != null) '_body': body,
    });
  }

  bool isAppointmentRequestText(String? title, String? body) {
    return _isAppointmentRequest({
      if (title != null) '_title': title,
      if (body != null) '_body': body,
    });
  }

  bool isAppointmentNotificationText(String? title, String? body) {
    return isPaymentNotificationText(title, body) ||
        isAppointmentRequestText(title, body);
  }

  void openAppointmentFromNotificationText(String? title, String? body) {
    final isPayment = isPaymentNotificationText(title, body);
    handleNotificationOpen({
      'screen': isPayment
          ? NotificationRoutes.appointmentsProcessing
          : NotificationRoutes.appointmentsApproved,
      if (title != null) '_title': title,
      if (body != null) '_body': body,
    });
    Get.offAllNamed('/home');
  }

  String? _resolveScreen(Map<String, dynamic> data) {
    if (_isPaymentProcessingUpdate(data)) {
      return NotificationRoutes.appointmentsProcessing;
    }
    // Appointment requests must win even when backend sends notification_screen.
    if (_isAppointmentRequest(data)) {
      return NotificationRoutes.patientRequests;
    }

    final screen = data['screen']?.toString();
    if (screen == NotificationRoutes.appointmentsProcessing ||
        screen == 'appointment_processing' ||
        screen == 'processing_appointments') {
      return NotificationRoutes.appointmentsProcessing;
    }
    if (screen == NotificationRoutes.appointmentsApproved ||
        screen == 'approved_appointments' ||
        screen == 'appointment_approved') {
      return NotificationRoutes.appointmentsApproved;
    }
    if (screen == NotificationRoutes.patientRequests ||
        screen == 'appointment_request' ||
        screen == 'appointment_requests') {
      return NotificationRoutes.patientRequests;
    }
    if (screen != null && screen.isNotEmpty) return screen;
    return null;
  }

  void _applyNavigation(Map<String, dynamic> data) {
    final screen = _resolveScreen(data);
    if (kDebugMode) {
      debugPrint('Notification navigation → screen: $screen, data: $data');
    }
    if (screen == null) return;

    switch (screen) {
      case NotificationRoutes.patientRequests:
        if (Get.isRegistered<BottomNavController>()) {
          final nav = Get.find<BottomNavController>();
          nav.currentIndex = NotificationRoutes.patientRequestsTabIndex;
          nav.update();
        }
        if (Get.isRegistered<PatientRequestController>()) {
          Get.find<PatientRequestController>().loadRequests();
        }
        break;
      case NotificationRoutes.appointmentsProcessing:
        if (Get.isRegistered<BottomNavController>()) {
          final nav = Get.find<BottomNavController>();
          nav.currentIndex = NotificationRoutes.appointmentsTabIndex;
          nav.update();
        }
        if (Get.isRegistered<PatientRequestController>()) {
          final requestController = Get.find<PatientRequestController>();
          requestController.currentTab = NotificationRoutes.processingSubTabIndex;
          requestController.loadRequests();
          requestController.update();
        }
        break;
      case NotificationRoutes.appointmentsApproved:
        if (Get.isRegistered<BottomNavController>()) {
          final nav = Get.find<BottomNavController>();
          nav.currentIndex = NotificationRoutes.appointmentsTabIndex;
          nav.update();
        }
        if (Get.isRegistered<PatientRequestController>()) {
          final requestController = Get.find<PatientRequestController>();
          requestController.currentTab = NotificationRoutes.approvedSubTabIndex;
          requestController.loadRequests();
          requestController.update();
        }
        break;
      case NotificationRoutes.notificationList:
        Get.toNamed('/notification');
        break;
      default:
        if (kDebugMode) {
          debugPrint('Unhandled notification screen: $screen');
        }
    }
  }

  // Initialize Firebase Messaging
  void initFirebaseMessaging() async {
    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      try{
        PatientRequestController controller = Get.find<PatientRequestController>();
        controller.loadRequests();
      }catch(e){
        if(kDebugMode){
          print("Foreground request loading error-->${e.toString()}");
        }
      }
      print(
          'Received a message in the foreground: ${message.notification?.body}');

      // Show local notification with sound
      if (message.notification != null) {
        showLocalNotification(
          message.notification?.title,
          message.notification?.body,
          _routingDataFrom(message),
        );
        unreadCount++;
      }
      await allNotifications();
    });
  }

  // Handle messages when the app is in the background or terminated
  void setupInteractedMessage() async {
    // When the app is in the background and opened by tapping the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationOpen(_routingDataFrom(message));
    });

    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        debugPrint(
          'getInitialMessage → data: ${initialMessage.data}, '
          'title: ${initialMessage.notification?.title}, '
          'body: ${initialMessage.notification?.body}',
        );
      }
      handleNotificationOpen(_routingDataFrom(initialMessage));
    }
  }

  // Initialize Local Notifications Plugin
  void initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');


    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      String? payload = response.payload;
      print('Payload on notification click: $payload'); // Add this line
      if (payload != null) {
        handleNotificationOpen({'screen': payload});
      }
    });
  }

  // Show a local notification with sound
  void showLocalNotification(
      String? title, String? body, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Care2CareTaker',
      channelDescription: 'Appointment and account notifications',
      icon: '@mipmap/ic_launcher',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
    );

    DarwinNotificationDetails initializationSettingsIOS = const DarwinNotificationDetails();

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: initializationSettingsIOS);

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title ?? 'Default Title',
        body ?? 'Default Body',
        platformChannelSpecifics,
        payload: _resolveScreen({
          ...data,
          if (title != null) '_title': title,
          if (body != null) '_body': body,
        }),
      );
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Local notification error: $e\n$stack');
      }
    }
  }

  bool loadNotification = false;
  ReceiveNotification? receiveNotification;
  List<AllNotification> listNotification = [];
  String? Count;


  allNotifications() async {
    loadNotification = true;
    update();
    String? token = await SharedPref().getToken();
     try {
    var res = await HttpService.instance.get(
      Uri.parse(URls().allNotifications),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      receiveNotification = receiveNotificationFromJson(res.body);
      listNotification = List<AllNotification>.from(
        receiveNotification?.notifications ?? [],
      );
      unreadCount = receiveNotification?.unreadCount ?? 0;
      update();
      print("Fetch Successfully");
    } else {
      debugPrint("message fetch not successfully ");
    }
     } catch (d) {
      debugPrint(d.toString());
    }
    loadNotification = false;
    update();
  }

  bool viewedNotification = false;

  notificationsUnread() async {
    viewedNotification = true;
    update();
    String? token = await SharedPref().getToken();
    var request = await HttpService.instance.post(
      Uri.parse(URls().markAllUnread),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (request.statusCode == 200) {
      unreadCount = 0;
      update();
    } else {}
    viewedNotification = false;
    update();
  }


  Future<void> deleteNotification(String notificationId) async {
    String? token = await SharedPref().getToken();
    try {
      var res = await HttpService.instance.delete(
        Uri.parse("${URls().deleteNotification}/$notificationId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        listNotification.removeWhere((notification) => notification.id == notificationId);
        update();
        showCustomToast(message: "Notification deleted successfully");
      } else {
        debugPrint("Failed to delete notification: ${res.body}");
        showCustomToast(message: "Failed to delete notification");
      }
    } catch (e) {
      debugPrint("Exception while deleting notification: $e");
      showCustomToast(message: "An error occurred while deleting the notification");
    }
  }
}
