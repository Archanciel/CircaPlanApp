class DateTimeParser {
  static final RegExp regExp = RegExp(r'^(\d+-\d+)\s(\d+:\d{2})');

  static List<String?> parseDateTime(String dateTimrStr) {
    RegExpMatch? match = regExp.firstMatch(dateTimrStr);
    String? dayMonth = match?.group(1);
    String? hourMinute = match?.group(2);

    return [dayMonth, hourMinute];
  }
}

void main() {
  final List<String> dateTimeStrLst = [
    '14-12 13:35',
    '4-2 3:05',
    'a4-2 3:05',
    '14-2 3:u5',
    '14-2 3:5',
  ];

  for (String str in dateTimeStrLst) {
    List<String?> dateTimeStrLst = DateTimeParser.parseDateTime(str);
    String? dayMonth = dateTimeStrLst[0];
    String? hourMinute = dateTimeStrLst[1];
    print('$str: $dayMonth $hourMinute');
  }
}
