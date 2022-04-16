import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  const String locale = "fr";

  initializeDateFormatting(locale);

  final dateFormatNotLocal = DateFormat("dd-MM-yyyy HH:mm");
  final dateString = dateFormatNotLocal.format(DateTime.now());
  print('dateFormatNotLocal: $dateString');

  final DateTime date = dateFormatNotLocal.parse(dateString);
  print('default date time format: $date');

  final dateFormatEEEELocal = DateFormat("EEEE dd-MM-yy HH:mm", locale);
  print('dateFormatEEEELocal: ${dateFormatEEEELocal.format(date)}');

  final dateTimeFormatConstLocal = DateFormat.yMMMMEEEEd(locale).add_Hm();
  print('dateTimeFormatConstLocal: ${dateTimeFormatConstLocal.format(date)}');

    print('dateTimeFormatConstLocal: ${dateTimeFormatConstLocal.format(DateTime(2019, 06, 06, 12, 34))}');

}
