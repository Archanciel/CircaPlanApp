import 'package:intl/intl.dart';

class DateTimeComputer {
  DateTime computeGoToSleepHour(
      {required String wakeUpDateTimeStr,
      required String wakeHourMinuteDurationStr}) {
    final DateTime wakeUpDT =
        DateFormat('dd-MM-yyyy HH:mm').parseLoose(wakeUpDateTimeStr);

    final List<String> hhmmLst = wakeHourMinuteDurationStr.split(':');
    final int wakeHours = int.parse(hhmmLst[0]);
    final int wakeMinutes = int.parse(hhmmLst[1]);

    return wakeUpDT.add(Duration(hours: wakeHours, minutes: wakeMinutes));
  }
}

void main() {
  DateTimeComputer dateTimeComputer = DateTimeComputer();

  final String wakeUpDateTime = '15-04-2022 18:15';
  final String  wakeHourMinuteDuration = '20:30';
  print(
      '$wakeUpDateTime + $wakeHourMinuteDuration = ${dateTimeComputer.computeGoToSleepHour(wakeUpDateTimeStr: wakeUpDateTime, wakeHourMinuteDurationStr: wakeHourMinuteDuration)}');
  print(dateTimeComputer.computeGoToSleepHour(
      wakeUpDateTimeStr: '15-4-22 18:15', wakeHourMinuteDurationStr: '20:30'));
}
