import 'package:intl/intl.dart';

class DateTimeComputer {
  DateTime computeGoToSleepHour(
      String wakeUpDateTime, String wakeHourMinuteDuration) {
    //DateTime wakeUp =
    DateTime dateTime = DateFormat('dd-MM-yyyy h:mm:ssa', 'en_US')
        .parseLoose('01-11-2020 2:00:00AM');
        
    return dateTime;
  }
}
