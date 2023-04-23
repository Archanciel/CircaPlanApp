import 'package:fluttertoast/fluttertoast.dart';

import '../screens/screen_mixin.dart';

class CircadianFlutterToast with ScreenMixin {
  static showToast({
    required String message,
    ToastGravity positionWorkingOnOldAndroid = ToastGravity.CENTER,
    bool isError = false,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: positionWorkingOnOldAndroid, // Ok on Android version smaller than 13.0
      backgroundColor: (isError)
          ? ScreenMixin.APP_WARNING_COLOR
          : ScreenMixin.APP_DARK_BLUE_COLOR,
      timeInSecForIosWeb: (isError) ? 2 : 1,
      textColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
    );
  }
}
