import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotiController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> toggleSub({required bool turnOn}) async {
    if (turnOn) {
      await messaging.subscribeToTopic('all');
      print("JKJKKK Subscribed");
    } else
      await messaging.unsubscribeFromTopic('all');
    print("JKJKKK  UnSubscribed");
  }

  void handleNoti() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        //TODO open new page from noti
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      //TODO open new page from noti
    });
  }
}
