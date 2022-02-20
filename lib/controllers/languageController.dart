import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pref_controller.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final PrefController pref = Get.find();
  late Locale _locale;
  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    Get.updateLocale(locale);
    _locale = locale;
    update();
    pref.to.setString(
        'languageCode', locale.languageCode + "_" + locale.countryCode!);
  }

  getLocaleFromPreferences() async {
    print("getLocaleFromPref");
    Locale local;
    Locale loc = Get.deviceLocale!;
    String? savedLocale = pref.to.getString('languageCode');
    try {
      if (savedLocale == null) {
        Get.updateLocale(loc);
      } else {
        var _split = savedLocale.split('_');
        local =
            Locale.fromSubtags(languageCode: _split[0], countryCode: _split[1]);
        Get.updateLocale(local);
      }
    } catch (e) {
      local = Get.deviceLocale!;
      print("Locale fetch error " + e.toString());
    }
    // setLocale(local);
  }

  String getLocaleString() {
    String? savedLocale = pref.to.getString('languageCode');
    try {
      if (savedLocale == null) {
        return "English";
      } else {
        var _split = savedLocale.split('_');
        return _split[0];
      }
    } catch (e) {
      print("Locale fetch error " + e.toString());
      return "English";
    }
  }
}
