import 'package:flutter/material.dart';

import '../screens/screen_mixin.dart';

/// This widget extends SnackBar and accept the String snackBar
/// content as constructor parameter.
/// 
/// Using CircadianSnackBar
///
/// final CircadianSnackBar snackBar = 
///   CircadianSnackBar(message: 'Bad new date time !');
/// ScaffoldMessenger.of(context).showSnackBar(snackBar);
class CircadianSnackBar extends SnackBar with ScreenMixin {
  CircadianSnackBar({required String message})
      : super(
          content: Text(
            message,
            style: const TextStyle(
              color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
            ),
          ),
          backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
          duration: const Duration(milliseconds: 2000),
        );
}
