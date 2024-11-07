// To parse this JSON data, do
//
//     final receiveNotification = receiveNotificationFromJson(jsonString);

import 'dart:convert';

ReceiveNotification receiveNotificationFromJson(String str) => ReceiveNotification.fromJson(json.decode(str));

String receiveNotificationToJson(ReceiveNotification data) => json.encode(data.toJson());

class ReceiveNotification {
  List<AllNotification>? notifications;
  int? unreadCount;
  ReceiveNotification({
    this.notifications,
    this.unreadCount
  });

  factory ReceiveNotification.fromJson(Map<String, dynamic> json) => ReceiveNotification(
    notifications: json["notifications"] == null ? [] : List<AllNotification>.from(json["notifications"]!.map((x) => AllNotification.fromJson(x))),
    unreadCount: json["unread_count"],
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "unread_count": unreadCount,
  };
}

class AllNotification {
  String? id;
  Data? data;
  DateTime? createdAt;
  dynamic readAt;

  AllNotification({
    this.id,
    this.data,
    this.createdAt,
    this.readAt,
  });

  factory AllNotification.fromJson(Map<String, dynamic> json) => AllNotification(
    id: json["id"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    readAt: json["read_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "data": data?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "read_at": readAt,
  };
}

class Data {
  String? title;
  String? body;
  String? screen;

  Data({
    this.title,
    this.body,
    this.screen,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    body: json["body"],
    screen: json["screen"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "screen": screen,
  };
}
