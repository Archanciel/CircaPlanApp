import 'package:intl/intl.dart';

void main() {
  List<String> sleepTimeHistoryLst = [
    "09-09-2023 17:17",
    "0:22",
    "0:08",
    "0:15",
  ];

  List<String> wakeTimeHistoryLst = [
    "09-09-2023 17:39",
    "0:10",
    "0:12",
  ];

  List<String> sleepTimeDateTime = [
    // adding the first sleep date time to the sleepDateTime
    // list
    "${sleepTimeHistoryLst[0]}, ${sleepTimeHistoryLst[1]}"
  ];

  List<String> wakeTimeDateTime = [
    // adding the first wake date time to the wakeDateTime
    // list
    "${wakeTimeHistoryLst[0]}, ${wakeTimeHistoryLst[1]}"
  ];

  for (int i = 1; i < sleepTimeHistoryLst.length - 1; i++) {
    if (i == 1) {
      // computing the second sleep date time
      DateTime sleepTime = DateFormat('dd-MM-yyyy HH:mm')
          .parse(sleepTimeHistoryLst[i - 1])
          .add(Duration(minutes: _getMinutes(sleepTimeHistoryLst[i])))
          .add(Duration(minutes: _getMinutes(wakeTimeHistoryLst[i])));

      sleepTimeDateTime.add(
          "${DateFormat('dd-MM-yyyy HH:mm').format(sleepTime)}, ${sleepTimeHistoryLst[i + 1]}");
    } else {
      DateTime sleepTime = DateFormat('dd-MM-yyyy HH:mm')
          .parse(sleepTimeDateTime[i - 1])
          .add(Duration(minutes: _getMinutes(sleepTimeHistoryLst[i])))
          .add(Duration(minutes: _getMinutes(wakeTimeHistoryLst[i])));

      sleepTimeDateTime.add(
          "${DateFormat('dd-MM-yyyy HH:mm').format(sleepTime)}, ${sleepTimeHistoryLst[i + 1]}");
    }
  }

  print("Sleep date time list");
  for (String sleepDateTimeStr in sleepTimeDateTime) {
    print(sleepDateTimeStr);
  }

  int i = 2;

  for (String sleepDateTimeStr in sleepTimeDateTime.sublist(1)) {
    if (i < wakeTimeHistoryLst.length) {
      DateTime wakeDateTime = DateFormat('dd-MM-yyyy HH:mm')
          .parse(sleepDateTimeStr.split(',')[0])
          .add(Duration(minutes: _getMinutes(sleepDateTimeStr.split(',')[1])));
      wakeTimeDateTime.add(
          "${DateFormat('dd-MM-yyyy HH:mm').format(wakeDateTime)}, ${wakeTimeHistoryLst[i++]}");
    }
  }

  print("\nWake date time list");
  for (String wakeDateTimeStr in wakeTimeDateTime) {
    print(wakeDateTimeStr);
  }
}

int _getMinutes(String timeStr) {
  List<String> parts = timeStr.split(':');
  if (parts.length == 2) {
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
  return int.parse(timeStr);
}

String _formatDuration(Duration d) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  String twoDigitHours = twoDigits(d.inHours);
  return "$twoDigitHours:$twoDigitMinutes";
}
