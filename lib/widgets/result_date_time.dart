import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

class ResultDateTime extends StatelessWidget with ScreenMixin {
  final TextEditingController _resultDateTimeController;

  ResultDateTime({
    required TextEditingController resultDateTimeController,
  })  : _resultDateTimeController = resultDateTimeController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'End date time',
            style: TextStyle(
              color: appLabelColor,
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
            ),
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
                // cursorColor: appTextAndIconColor,
              ),
            ),
            child: TextField(
              decoration: const InputDecoration.collapsed(hintText: ''),
              style: TextStyle(
                  color: appTextAndIconColor,
                  fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                  fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
              controller: _resultDateTimeController,
            ),
          ),
        ],
      ),
    );
  }
}
