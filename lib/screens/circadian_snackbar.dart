import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/material.dart';

import 'screen_mixin.dart';

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
          backgroundColor: ScreenMixin.APP_SELECTION_COLOR,
        );
}
