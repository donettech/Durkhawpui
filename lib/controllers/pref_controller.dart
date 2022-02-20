import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefController extends GetxController {
  late SharedPreferences _pref;

  SharedPreferences get to => _pref;

  Future<void> setUp() async {
    _pref = await SharedPreferences.getInstance();
  }
}
