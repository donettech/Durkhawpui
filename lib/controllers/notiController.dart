import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/ui/home/NoticeDetails/NoticeDetail.dart';
import 'package:durkhawpui/ui/home/NoticeDetails/notice_detail_link.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class NotiController extends GetxController {
  final _messaging = FirebaseMessaging.instance;
  final _fire = FirebaseFirestore.instance;
  final String fcmURL = 'https://fcm.googleapis.com/fcm/send';

  Future<String> getToken() async {
    var _token = await _messaging.getToken() ?? "";
    log("FCM token-> $_token");
    return _token;
  }

  Future toggleSub({required bool turnOn}) {
    if (turnOn) {
      return _messaging.subscribeToTopic('general');
    } else {
      return _messaging.unsubscribeFromTopic('general');
    }
  }

  Future<void> setupMessaging() async {
    RemoteMessage? initialMsg = await _messaging.getInitialMessage();
    if (initialMsg != null) {
      log('initial message not empty ' + initialMsg.toString());
      Map<String, dynamic> data = initialMsg.data;
      log("Notification opened app initial msg->" + data.toString());
      handlePayload(data, false);
    } else {
      log('initial message empty');
      FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
        log("Notification during app open->" + event.data.toString());
        showLocalNoti(event);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) async {
        Map<String, dynamic> data = event.data;
        log("Notification during app close->" + event.data.toString());
        handlePayload(data, false);
      });
    }
  }

  void handlePayload(Map payload, bool isLocal) async {
    Map<dynamic, dynamic> data = payload;
    var type = data['type'];
    if (isLocal) {
      switch (type.toString().toLowerCase()) {
        case "general":
          {
            Get.dialog(Center(
              child: CupertinoActivityIndicator(),
            ));
            try {
              String itemId = data['id'];
              var snap = await _fire.collection('posts').doc(itemId).get();
              Notice _notice = Notice.fromJson(snap.data()!, snap.id);
              Get.back();
              Get.to(() => NoticeDetails(notice: _notice));
            } catch (e) {
              Get.back();
            }
            break;
          }
      }
    } else {
      switch (type.toString().toLowerCase()) {
        case "general":
          String itemId = data['id'];
          runApp(
            GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: NoticeDetailLink(noticeId: itemId),
            ),
          );
          break;
      }
    }
  }

  void showLocalNoti(RemoteMessage event) async {
    log(event.notification.toString());
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Constants.channelId,
      Constants.channelName,
      channelDescription: Constants.channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: IOSInitializationSettings(),
      ),
      onSelectNotification: (payload) async {
        try {
          Map _js = jsonDecode(payload ?? '');
          if (_js.entries.isNotEmpty) {
            handlePayload(_js, true);
          }
        } catch (e) {
          log(e.toString());
        }
      },
    );
    if (event.notification != null) {
      RemoteNotification? notification = event.notification;
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          1,
          notification?.title ?? "Durkhawpui Notification",
          notification?.body ?? "",
          platformChannelSpecifics,
          payload: jsonEncode(event.data));
    } else {
      Map<String, dynamic> data = event.data['notification'];
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          1, data['title'], data['body'], platformChannelSpecifics,
          payload: jsonEncode(event.data['data']));
    }
  }

  Future<bool?> sendMessage({
    required String title,
    required String excerpt,
    required itemId,
  }) async {
    try {
      var body = {
        "notification": {
          "title": title,
          "body": excerpt,
          "sound": "default",
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
        "data": {
          "title": title,
          "body": excerpt,
          "id": itemId,
          "type": "general",
        },
        "to": "/topics/general",
      };
      var result = await GetConnect().post(
        fcmURL,
        jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "key=" + Constants.fcmKey,
        },
      );
      if (result.statusCode == 200) {
        log('FCM result=>' + result.body.toString());
        return true;
      } else {
        log("Error sending message->" + result.body);
        return false;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
