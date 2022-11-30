import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// Widget displaying date time value in a TextField.
/// 
/// This widget ios included in the AddSubtractDuration widget.
class ResultDateTime extends StatelessWidget with ScreenMixin {
  final TextEditingController _resultDateTimeController;

  ResultDateTime({
    required TextEditingController resultDateTimeController,
  })  : _resultDateTimeController = resultDateTimeController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, kVerticalFieldDistance, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'End date time',
            style: labelTextStyle,
          ),
          const SizedBox(
            height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: selectionColor,
                // commenting cursorColor discourage manually
                // editing the TextField !
                // cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
              ),
            ),
            child: TextField(
              decoration: const InputDecoration.collapsed(hintText: ''),
              style: const TextStyle(
                  color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                  fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                  fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
              controller: _resultDateTimeController,
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
}
