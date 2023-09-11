import 'package:intl/intl.dart';

class HistoryComputerService {
  Map<String, List<String>> computeSleepWakeHistoryLst({
    required List<String> sleepTimeHistoryLst,
    required List<String> wakeTimeHistoryLst,
  }) {
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

    int i = 2;

    for (String sleepDateTimeStr in sleepTimeDateTime.sublist(1)) {
      if (i < wakeTimeHistoryLst.length) {
        DateTime wakeDateTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse(sleepDateTimeStr.split(',')[0])
            .add(
                Duration(minutes: _getMinutes(sleepDateTimeStr.split(',')[1])));
        wakeTimeDateTime.add(
            "${DateFormat('dd-MM-yyyy HH:mm').format(wakeDateTime)}, ${wakeTimeHistoryLst[i++]}");
      } else {
        // in case the last wake date time is not followed
        // by a sleep date time, we add the last wake date
        // time to the wake date time list
        DateTime wakeDateTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse(sleepDateTimeStr.split(',')[0])
            .add(
                Duration(minutes: _getMinutes(sleepDateTimeStr.split(',')[1])));
        wakeTimeDateTime
            .add(DateFormat("dd-MM-yyyy HH:mm").format(wakeDateTime));
      }
    }

    Map<String, List<String>> sleepWakeHistoryLstMap = {};

    sleepWakeHistoryLstMap['sleepTimeDateTime'] = sleepTimeDateTime;
    sleepWakeHistoryLstMap['wakeTimeDateTime'] = wakeTimeDateTime;

    return sleepWakeHistoryLstMap;
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
}

void main() {
  List<String> sleepTimeHistoryLst = [
    "09-09-2023 02:57",
    "3:48",
    "4:02",
    "5:50"
  ];
  List<String> wakeTimeHistoryLst = [
    "09-09-2023 06:45",
    "0:38",
    "0:40",
    // "0:19" // in case the Sleep Duration is finished not in
    // wake but in sleep mode, which doesn't normally
    // happens !
  ];

  HistoryComputerService historyComputerService = HistoryComputerService();

  Map<String, List<String>> sleepWakeHistoryLstMap =
      historyComputerService.computeSleepWakeHistoryLst(
          sleepTimeHistoryLst: sleepTimeHistoryLst,
          wakeTimeHistoryLst: wakeTimeHistoryLst);

  print("\nSLEEP DATE TIME LIST ...");
  for (String sleepDateTimeStr
      in sleepWakeHistoryLstMap['sleepTimeDateTime']!) {
    print(sleepDateTimeStr);
  }

  print("\nWAKE DATE TIME LIST ...");
  for (String wakeDateTimeStr in sleepWakeHistoryLstMap['wakeTimeDateTime']!) {
    print(wakeDateTimeStr);
  }
}
