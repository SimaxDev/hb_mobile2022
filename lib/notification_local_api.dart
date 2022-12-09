// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
//
// class NotificationApi {
//
//   static final _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future _notificationDetails() async{
//      return NotificationDetails(
//        android:  AndroidNotificationDetails(
//            'channel id',
//            'channel name',
//             'channel description',
//            importance: Importance.max,),
//        iOS: IOSNotificationDetails(),
//      );
//
//   }
//
//
//   static Future showNotification({
//
//     int id = 0,
//     required String title,
//     String? body,
//     String? playload,
//
//
//   }) async =>
//       _notifications.show(
//         id,
//         title,
//         body,
//         await _notificationDetails(),
//       payload: playload);
//
//
// }