import 'package:intl/intl.dart';

class DateTimeComputer {
  static final NumberFormat _minuteFormatter = NumberFormat('00');

  /// According to the passed wake-up date/time string and the
  /// passed awakening hour:minute duration, returns the
  /// DateTime object which is the addition of the two passed
  /// parameters.
  ///
  /// [wakeUpDateTimeStr] ex:          '15-04-2022 18:15'
  /// [wakeHourMinuteDurationStr] ex:  '20:30'
  ///
  /// can throw [FormatException] in case of invalid params.
  /// Ex: '31-04-2022 18:15' or '15-04-2022 18.15'
  ///
  /// returns [DateTime]
  DateTime computeGoToSleepHour(
      {required String wakeUpDateTimeStr,
      required String wakeHourMinuteDurationStr}) {
    final DateTime wakeUpDT = _stringToDateTime(wakeUpDateTimeStr);

    final List<String> hhmmLst = wakeHourMinuteDurationStr.split(':');
    final int wakeHours = int.parse(hhmmLst[0]);
    final int wakeMinutes = int.parse(hhmmLst[1]);

    return wakeUpDT.add(Duration(hours: wakeHours, minutes: wakeMinutes));
  }

  /// can throw [FormatException] in case of invalid dateTimeStr
  /// format.
  DateTime _stringToDateTime(String dateTimeStr) =>
      DateFormat('dd-MM-yyyy HH:mm').parseLoose(dateTimeStr);

  ///
  /// can throw [FormatException] in case of invalid params
  /// format.
  /// can throw [ArgumentError] in case goToSleepDateTimeStr
  /// is not after the passed wakeUpDateTimeStr.
  /// Ex: '31-04-2022 18:15' or '15-04-2022 18.15'
  ///
  /// returns [DateTime]
  String computeWakeUpDuration(
      {required String wakeUpDateTimeStr,
      required String goToSleepDateTimeStr}) {
    final DateTime wakeUpDT = _stringToDateTime(wakeUpDateTimeStr);
    final DateTime goToSleepDT = _stringToDateTime(goToSleepDateTimeStr);
    final Duration wakeUpDuration = goToSleepDT.difference(wakeUpDT);

    final int wakeUpDurationMinute = wakeUpDuration.inMinutes.remainder(60);

    if (wakeUpDurationMinute < 1) {
      throw ArgumentError(
          'goToSleepDateTimeStr $goToSleepDateTimeStr must be after wakeUpDateTimeStr $wakeUpDateTimeStr');
    }

    return "${wakeUpDuration.inHours}:${DateTimeComputer._minuteFormatter.format(wakeUpDurationMinute)}";
  }
}

void main() {
  DateTimeComputer dateTimeComputer = DateTimeComputer();

  const String wakeUpDateTimeStr = '15-04-2022 18:15';
  const String wakeHourMinuteDuration = '20:30';
  DateTime computeGoToSleepDateTime = dateTimeComputer.computeGoToSleepHour(
      wakeUpDateTimeStr: wakeUpDateTimeStr,
      wakeHourMinuteDurationStr: wakeHourMinuteDuration);
  final dateFormatNotLocal = DateFormat("dd-MM-yyyy HH:mm");

  String wakeUpHHmmStr = dateTimeComputer.computeWakeUpDuration(
      wakeUpDateTimeStr: wakeUpDateTimeStr,
      goToSleepDateTimeStr:
          dateFormatNotLocal.format(computeGoToSleepDateTime));

  if (wakeUpHHmmStr != wakeHourMinuteDuration) {
    print('WARNING: BUG !');
  }

  const String goToSleepDateTimeStr = '17-4-2022 8:45';

  wakeUpHHmmStr = dateTimeComputer.computeWakeUpDuration(
      wakeUpDateTimeStr: wakeUpDateTimeStr,
      goToSleepDateTimeStr: goToSleepDateTimeStr);

  print(
      '\nyou waked up on $wakeUpDateTimeStr\nyou went to bed on $goToSleepDateTimeStr\nyou stayed awake: $wakeUpHHmmStr H');
}
