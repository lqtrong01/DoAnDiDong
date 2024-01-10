import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificationmanerger{
  final FlutterLocalNotificationsPlugin notificationPlusin=FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =const AndroidInitializationSettings('flutter_logo');
    DarwinInitializationSettings  initializationIos=DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) {
      },
    );
    InitializationSettings initializationSettings=InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationIos
    );
await notificationPlusin.initialize(initializationSettings,
onDidReceiveNotificationResponse: (details) {
  
},);
  }
  Future<void> clickshow() async{
    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
      'Channel_id',
      'Channel_titlie',
      priority: Priority.high,
      importance: Importance.max,
      icon: "flutter_logo",
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap('flutter_logo')
    );

    NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
    await notificationPlusin.show(0, "Chúc mùng bạn vừa thanh toán đơn hàng ", '1Kg táo đỏ', notificationDetails);
  }
  

 
}