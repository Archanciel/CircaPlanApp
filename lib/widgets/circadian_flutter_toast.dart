import 'package:fluttertoast/fluttertoast.dart';

import '../screens/screen_mixin.dart';

class CircadianFlutterToast with ScreenMixin {
  static showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
      timeInSecForIosWeb: 1,
      textColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
    );
  }
}
