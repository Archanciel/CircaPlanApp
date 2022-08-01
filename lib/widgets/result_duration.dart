import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

/// Widget included in AddSubtractDuration widget.
class ResultDuration extends StatelessWidget with ScreenMixin {
  final TextEditingController _resultDurationController;
  final String _resultDurationTitle;

  ResultDuration({
    required String resultDurationTitle,
    required TextEditingController resultDurationController,
  })  : _resultDurationTitle = resultDurationTitle,
        _resultDurationController = resultDurationController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _resultDurationTitle,
            style: TextStyle(
              color: appLabelColor,
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0), // val 5 is
//                                            compliant with current value 5 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                width: 160,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: selectionColor,
                      // commenting cursorColor discourage manually
                      // editing the TextField !
                      // cursorColor: appTextAndIconColor,
                    ),
                  ),
                  child: GestureDetector(
                    child: TextField(
                      style: TextStyle(
                          color: appTextAndIconColor,
                          fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                          fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      keyboardType: TextInputType.datetime,
                      controller: _resultDurationController,
                      readOnly: true,
                    ),
                    onDoubleTap: () async {
                      await copyToClipboard(
                          context: context,
                          controller: _resultDurationController);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
