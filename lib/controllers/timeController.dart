import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeController extends GetxController {
  var timeString = "".obs;

  @override
  void onInit() {
    super.onInit();
    startTime();
  }

  void startTime() {
    timeString.value = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    timeString.value = formattedDateTime;
    update(['aVeryUniqueID']);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('EEE dd-MMMM').format(dateTime);
  }
}
