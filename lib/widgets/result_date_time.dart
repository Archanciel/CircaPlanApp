import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

class ResultDateTime extends StatelessWidget with ScreenMixin {
  final TextEditingController _resultDateTimeController;
  final Function _updateTransferDataMap;

  ResultDateTime({
    required TextEditingController resultDateTimeController,
    required Function updateTransferDataMapFunction,
  })  : _resultDateTimeController = resultDateTimeController,
        _updateTransferDataMap = updateTransferDataMapFunction;
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
              // The validator receives the text that the user has entered.
              controller: _resultDateTimeController,
              onChanged: (val) {
                // called when manually updating the TextField
                // content. onChanged must be defined in order for
                // pasting a value to the TextField to really
                // modify the TextField value and store it
                // in the screen navigation transfer
                // data map.
                _resultDateTimeController.text = val;
                _updateTransferDataMap();
              },
            ),
          ),
        ],
      ),
    );
  }
}
