import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../screens/screen_mixin.dart';

class CircadianOkToast with ScreenMixin {
  static showToastMessage({
    required String message,
    required BuildContext context,
    ToastPosition positionWorkingOnOldAndroid = ToastPosition.center,
    bool isError = false,
  }) {
    showToast(
      message,
      context: context,
      duration: Duration(seconds: (isError) ? 2 : 1),
      dismissOtherToast: true,
      backgroundColor: (isError)
          ? ScreenMixin.APP_WARNING_COLOR
          : ScreenMixin.APP_DARK_BLUE_COLOR,
      textPadding: const EdgeInsets.all(10.0),
      textStyle: const TextStyle(
          color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
          fontSize: ScreenMixin.APP_TEXT_FONT_SIZE),
      position: positionWorkingOnOldAndroid == ToastPosition.center
          ? ToastPosition.center
          : ToastPosition.bottom,
    );
  }
}
