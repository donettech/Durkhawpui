import 'package:intl/intl.dart';

String getDate({required DateTime time, required String format}) {
  var date = DateFormat(format).format(time);
  return date;
}

String timeAgo(DateTime datetime) {
  DateTime d1 = DateTime.now();
  DateTime d2 = datetime;

  //Difference between now and given time in minutes
  var minutes = int.parse((d1.difference(d2)).inMinutes.toString());

  switch (minutes) {
    case 0:
      return "Just Now";

    case 1:
      return "1 min ago";

    case 2:
      return "2 mins ago";

    //If it is more than two minutes return no. of hours.
    default:
      return hourFormatter(datetime);
  }
}

String hourCalculate(DateTime datetime) {
  DateTime d1 = DateTime.now();
  DateTime d2 = datetime;

  var diff = d1.difference(d2); //d2-d1
  return ((diff.inHours).toString());
}

String formatDate(DateTime date) {
  var _new = DateFormat("h:mm a dd-MMMM-yy").format(date);
  return _new;
}

String hourFormatter(DateTime datetime) {
  var hours = int.parse(hourCalculate(datetime));

  switch (hours) {
    case 0:
      return "Few minutes ago";

    case 1:
      return "1 hour ago";

    case 2:
      return "2 hours ago";

    //Converted into days for more than 2 hours
    default:
      return dayFormatter(datetime);
  }
}

String dayCalculate(DateTime datetime) {
  DateTime d1 = DateTime.now();
  DateTime d2 = datetime;

  var diff = d1.difference(d2); //d2-d1
  return ((diff.inDays).toString());
}

String dayFormatter(DateTime datetime) {
  var days = int.parse(dayCalculate(datetime));

  switch (days) {
    case 0:
      return getTimeOnly(datetime) + " Today";

    case 1:
      return getTimeOnly(datetime) + " Yesterday";

    case 2:
      return "2 days ago";

    // Return the given time if the difference is more than 2 days.
    default:
      return getDateOnly(datetime);
  }
}

String getTimeOnly(DateTime date) {
  return DateFormat('hh:mma').format(date);
}

String getDateOnly(DateTime date) {
  DateTime d1 = date;
  return DateFormat.yMMMd().format(d1);
}
