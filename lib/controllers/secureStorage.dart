import 'package:durkhawpui/controllers/notiController.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureController extends GetxController {
  final storage = new FlutterSecureStorage();

  Future<bool> isFirstTime() async {
    var value = await storage.read(key: 'skipped');
    if (value != null && value == 'true') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> skip() async {
    storage.write(key: 'skipped', value: true.toString());
  }

  Future<bool> switchNoti({required bool newValue}) async {
    await storage.write(key: 'notification', value: newValue.toString());
    await Get.find<NotiController>().toggleSub(turnOn: newValue);
    return true;
  }

  Future<bool> checkNotiStatus() async {
    var str = await storage.read(key: 'notification');
    if (str != null && str == "true") {
      return true;
    } else
      return false;
  }
}
