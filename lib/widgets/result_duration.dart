import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

/// Widget that displays duration HH:MM value as well as
/// percentage.
class ResultDuration extends StatelessWidget with ScreenMixin {
  final String _resultDurationTitle;
  final TextEditingController _resultDurationController;
  final TextEditingController _resultDurationPercentController;

  ResultDuration({
    required String resultDurationTitle,
    required TextEditingController resultDurationController,
    required TextEditingController resultDurationPercentController,
  })  : _resultDurationTitle = resultDurationTitle,
        _resultDurationController = resultDurationController,
        _resultDurationPercentController = resultDurationPercentController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _resultDurationTitle,
            style: labelTextStyle,
          ),
          const SizedBox(
            height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
          ),
          Row(
            children: [
              SizedBox(
                width: 55,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: selectionColor,
                      // commenting cursorColor discourage manually
                      // editing the TextField !
                      // cursorColor: ScreenMixin.appTextAndIconColor,
                    ),
                  ),
                  child: GestureDetector(
                    child: TextField(
                      style: valueTextStyle,
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
              SizedBox(
                width: 50,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: selectionColor,
                      // commenting cursorColor discourage manually
                      // editing the TextField !
                      // cursorColor: ScreenMixin.appTextAndIconColor,
                    ),
                  ),
                  child: GestureDetector(
                    child: TextField(
                      style: valueTextStyle,
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
              Text(
                ' %',
                style: valueTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
