import 'package:intl/intl.dart';

import '../constants.dart';

/// Provides methods for computing sleep and wake-up
/// history data displayed in an AlertDialog.
class HistoryComputerService {
  static Map<String, List<String>> computeSleepWakeHistoryLst({
    required List<String> screenSleepHistoryLst,
    required List<String> screenWakeUpHistoryLst,
    required Status status,
    required String newDateTimeStr,
  }) {
    // creating copies of passed screen history lists since
    // we may have to modify them
    List<String> screenSleepHistoryLstCopy = List.from(screenSleepHistoryLst);
    List<String> screenWakeUpHistoryLstCopy = List.from(screenWakeUpHistoryLst);

    List<int> indexesOfNegativeDurations = [];

    // finding the indexes of negative durations in the
    // screenSleepHistoryLstCopy
    for (int i = 0; i < screenSleepHistoryLstCopy.length; i++) {
      if (screenSleepHistoryLstCopy[i].contains(RegExp(r'^-[0-9:]*'))) {
        indexesOfNegativeDurations.add(i);
      }
    }

    // removing the negative durations from the
    // screenSleepHistoryLstCopy and their corresponding
    // wake-up entry in the screenWakeUpHistoryLstCopy.
    //
    // Removing last lines of the lists first.
    for (int i = indexesOfNegativeDurations.length - 1; i >= 0; i--) {
      screenSleepHistoryLstCopy.removeAt(indexesOfNegativeDurations[i]);
      screenWakeUpHistoryLstCopy.removeAt(indexesOfNegativeDurations[i] - 1);
    }

    List<String> dialogSleepHistoryLst = [];

    // handling the first sleep situation ...

    if (screenSleepHistoryLstCopy.length >= 2) {
      // adding the first sleep date time and first sleep
      // duration to the dialogSleepHistoryLst
      dialogSleepHistoryLst = [
        "${screenSleepHistoryLstCopy[0]}, ${screenSleepHistoryLstCopy[1]}"
      ];
    } else if (screenSleepHistoryLstCopy.length == 1) {
      // adding the first sleep date time with no duration
      // to the dialogSleepHistoryLst
      dialogSleepHistoryLst = [
        screenSleepHistoryLstCopy[0],
      ];
    }

    List<String> dialogWakeUpHistoryLst = [];

    if (screenWakeUpHistoryLstCopy.length >= 2) {
      // adding the first wake-up date time and first
      // wake-up duration to the dialogWakeUpHistoryLst
      dialogWakeUpHistoryLst = [
        "${screenWakeUpHistoryLstCopy[0]}, ${screenWakeUpHistoryLstCopy[1]}"
      ];
    } else if (screenWakeUpHistoryLstCopy.length == 1) {
      // adding the first wake-up date time with no duration
      // to the dialogWakeUpHistoryLst
      dialogWakeUpHistoryLst = [screenWakeUpHistoryLstCopy[0]];
    }

    for (int i = 1; i < screenSleepHistoryLstCopy.length - 1; i++) {
      if (i == 1) {
        // computing the second sleep date time
        DateTime sleepTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse(screenSleepHistoryLstCopy[i - 1])
            .add(Duration(minutes: _getMinutes(screenSleepHistoryLstCopy[i])))
            .add(Duration(minutes: _getMinutes(screenWakeUpHistoryLstCopy[i])));

        dialogSleepHistoryLst.add(
            "${DateFormat('dd-MM-yyyy HH:mm').format(sleepTime)}, ${screenSleepHistoryLstCopy[i + 1]}");
      } else {
        DateTime sleepTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse(dialogSleepHistoryLst[i - 1])
            .add(Duration(minutes: _getMinutes(screenSleepHistoryLstCopy[i])))
            .add(Duration(minutes: _getMinutes(screenWakeUpHistoryLstCopy[i])));

        dialogSleepHistoryLst.add(
            "${DateFormat('dd-MM-yyyy HH:mm').format(sleepTime)}, ${screenSleepHistoryLstCopy[i + 1]}");
      }
    }

    int i = 2;

    for (String sleepDateTimeStr in dialogSleepHistoryLst.sublist(1)) {
      if (i < screenWakeUpHistoryLstCopy.length) {
        // in case the wake-up date time is followed by a
        // sleep date time, we calculate the last wake-up
        // date time and add it with the calculated wake-up
        // duration to the dialogWakeUpHistoryLst
        DateTime wakeDateTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse(sleepDateTimeStr.split(',')[0])
            .add(
                Duration(minutes: _getMinutes(sleepDateTimeStr.split(',')[1])));
        dialogWakeUpHistoryLst.add(
            "${DateFormat('dd-MM-yyyy HH:mm').format(wakeDateTime)}, ${screenWakeUpHistoryLstCopy[i++]}");
      } else {
        // in case the last wake-up date time is not followed
        // by a sleep date time, we add the last wake-up date
        // time without wake-up duration to the
        // dialogWakeUpHistoryLst
        DateTime wakeDateTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse(sleepDateTimeStr.split(',')[0])
            .add(
                Duration(minutes: _getMinutes(sleepDateTimeStr.split(',')[1])));
        dialogWakeUpHistoryLst
            .add(DateFormat("dd-MM-yyyy HH:mm").format(wakeDateTime));
      }
    }

    if (dialogWakeUpHistoryLst.isNotEmpty && status == Status.sleep) {
      // if we are not in the first sleep situation, which
      // is handled at the begining of this method,
      // and if the current status is sleep, the new date
      // which is the sleep start date time is added with
      // no duration to the dialogSleepHistoryLst
      dialogSleepHistoryLst.add(newDateTimeStr);
    }

    Map<String, List<String>> sleepWakeHistoryLstMap = {};

    sleepWakeHistoryLstMap['sleepTimeDateTime'] = dialogSleepHistoryLst;
    sleepWakeHistoryLstMap['wakeTimeDateTime'] = dialogWakeUpHistoryLst;

    return sleepWakeHistoryLstMap;
  }

  static int _getMinutes(String timeStr) {
    List<String> parts = timeStr.split(':');
    if (parts.length == 2) {
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }
    return int.parse(timeStr);
  }

  static String _formatDuration(Duration d) {
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

  Map<String, List<String>> sleepWakeHistoryLstMap =
      HistoryComputerService.computeSleepWakeHistoryLst(
          screenSleepHistoryLst: sleepTimeHistoryLst,
          screenWakeUpHistoryLst: wakeTimeHistoryLst,
          status: Status.sleep,
          newDateTimeStr: "09-09-2023 02:57");

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
