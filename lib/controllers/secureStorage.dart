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
}
