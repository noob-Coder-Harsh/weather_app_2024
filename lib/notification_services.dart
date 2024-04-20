// import 'dart:async';
// import 'dart:io';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initLocalNotifications() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//     InitializationSettings(android: androidInitializationSettings);
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//       final AndroidNotification? android = event.notification?.android;
//       if (kDebugMode) {
//         debugPrint('count: ${android?.count}');
//         debugPrint('data: ${event.data.toString()}');
//       }
//       if (Platform.isAndroid) {
//         initLocalNotifications();
//         showNotifications(event);
//       }
//     });
//   }
//
//   Future<void> requestNotificationPermission() async {
//     final NotificationSettings settings =
//     await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional');
//     } else {
//       debugPrint('User denied');
//     }
//   }
//
//   Future<void> showNotifications(RemoteMessage message) async {
//     final AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'channel_id',
//       'High Importance Notifications',
//       importance: Importance.max,
//     );
//
//     await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
//       channel,
//     );
//
//     final AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       channel.id,
//       channel.name,
//       channelDescription: 'Your channel description',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     final NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? '',
//       message.notification?.body ?? '',
//       notificationDetails,
//       payload: message.data.toString(),
//     );
//   }
//
//   Future<String> getDeviceToken() async {
//     final String? token = await messaging.getToken();
//     return token ?? '';
//   }
//
//   void isTokenRefresh() {
//     messaging.onTokenRefresh.listen((String event) {
//       debugPrint('Token refreshed: $event');
//     });
//   }
//
//   Future<void> foregroundMessage() async {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//
//   // Schedule hourly notifications
//   Future<void> scheduleHourlyNotifications() async {
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Hourly Notification',
//       'This is your hourly weather update.',
//       _nextHourDateTime(),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'hourly_channel',
//           'Hourly Notifications',
//           channelDescription: 'Hourly weather update notifications',
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   // Schedule daily notifications
//   Future<void> scheduleDailyNotifications() async {
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       1,
//       'Daily Notification',
//       'This is your daily weather update.',
//       _dailyNotificationTime(),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_channel',
//           'Daily Notifications',
//           channelDescription: 'Daily weather update notifications',
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   // Get next hour datetime
//   tz.TZDateTime _nextHourDateTime() {
//     final now = tz.TZDateTime.now(tz.local);
//     final nextHour = now.add(const Duration(hours: 1));
//     return tz.TZDateTime(tz.local, nextHour.year, nextHour.month, nextHour.day,
//         nextHour.hour, 0);
//   }
//
//   // Get daily notification time (6:00 AM)
//   tz.TZDateTime _dailyNotificationTime() {
//     final now = tz.TZDateTime.now(tz.local);
//     final nextDaily = tz.TZDateTime(tz.local, now.year, now.month, now.day, 6);
//     return nextDaily.isBefore(now)
//         ? nextDaily.add(const Duration(days: 1))
//         : nextDaily;
//   }
// }
