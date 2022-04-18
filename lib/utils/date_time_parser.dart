class DateTimeParser {
  static final RegExp regExpDateTime = RegExp(r'^(\d+-\d+)\s(\d+:\d{2})');
  static final RegExp regExpTime = RegExp(r'^(\d+:\d{2})');

  static List<String?> parseDateTime(String dateTimrStr) {
    RegExpMatch? match = regExpDateTime.firstMatch(dateTimrStr);
    String? dayMonth = match?.group(1);
    String? hourMinute = match?.group(2);

    return [dayMonth, hourMinute];
  }

  static String? parseTime(String dateTimrStr) {
    RegExpMatch? match = regExpTime.firstMatch(dateTimrStr);
    String? hourMinute = match?.group(1);

    return hourMinute;
  }
}

void main() {
  const List<String> dateTimeStrLst = [
    '14-12 13:35',
    '4-2 3:05',
    'a4-2 3:05',
    '14-2 3:u5',
    '14-2 3:5',
  ];

  const List<String> timeStrLst = [
    '13:35',
    '3:05',
    '3:u5',
    '3:5',
    '14-12 13:35',
    '4-2 3:05',
    'a4-2 3:05',
  ];

  for (String str in dateTimeStrLst) {
    List<String?> dateTimeStrLst = DateTimeParser.parseDateTime(str);
    String? dayMonth = dateTimeStrLst[0];
    String? hourMinute = dateTimeStrLst[1];
    print('$str: $dayMonth $hourMinute');
  }

  print('');

  for (String str in timeStrLst) {
    String? hourMinute = DateTimeParser.parseTime(str);
    print('$str: $hourMinute');
  }
}
