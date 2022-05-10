import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  final String defaultLocale =
      Platform.localeName; // Returns locale string in the form 'en_US
  initializeDateFormatting(defaultLocale);

  final dateFormatNotLocal = DateFormat("dd-MM-yyyy HH:mm");
  var now = DateTime.now();
  final dateString = dateFormatNotLocal.format(now);
  print('dateFormatNotLocal: $dateString');

  final DateTime date = dateFormatNotLocal.parse(dateString);
  print('default date time format: $date');

  final dateFormatEEEELocal = DateFormat("EEEE dd-MM-yy HH:mm", defaultLocale);
  print('dateFormatEEEELocal: ${dateFormatEEEELocal.format(date)}');

  final dateTimeFormatConstLocal =
      DateFormat.yMMMMEEEEd(defaultLocale).add_Hm();
  print('dateTimeFormatConstLocal: ${dateTimeFormatConstLocal.format(date)}');

  print(
      'dateTimeFormatConstLocal: ${dateTimeFormatConstLocal.format(DateTime(2019, 06, 06, 12, 34))}');

  String dayOfWeek = DateFormat.EEEE(defaultLocale).format(now);
  print('dayOfWeek: $dayOfWeek');

  String dayMonth = DateFormat.MMMMd(defaultLocale).format(now);
  print('dayMonth: $dayMonth');

  String year = DateFormat.y(defaultLocale).format(now);
  print('year: $year');
}
