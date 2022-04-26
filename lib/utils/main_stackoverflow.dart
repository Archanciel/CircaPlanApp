// https://stackoverflow.com/questions/71985114/creating-a-dart-duration-with-negative-minute-number-does-not-succeed-is-there/71985115#71985115
void main() {
  print(Duration(hours: -1)); // -1:00:00.000000
  print(Duration.zero - Duration(hours: 1)); // -1:00:00.000000
  print(Duration(minutes: -1)); // 0:01:00.000000 instead of -0:01:00.000000
  print(Duration.zero - 
      Duration(minutes: 1)); // 0:01:00.000000 instead of -0:01:00.000000

  print(Duration(minutes: -1).inMinutes); // -1
  print((Duration.zero - Duration(minutes: 1)).inMinutes); // -1
}
