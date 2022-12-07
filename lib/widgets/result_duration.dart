import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

/// Widget that displays duration HH:MM value as well as
/// percentage.
class ResultDuration extends StatelessWidget with ScreenMixin {
  final String _resultDurationTitle;
  final Map<String, dynamic> _transferDataMap;
  final TextEditingController _resultDurationController;
  final TextEditingController _resultDurationPercentController;
  final String _previousDayPercentTitle;
  final TextEditingController _prevDayTotalPercentController;
  final TextEditingController _prevDayTotalController;
  final ToastGravity position;

  ResultDuration({
    required String resultDurationTitle,
    required Map<String, dynamic> transferDataMap,
    required TextEditingController resultDurationController,
    required TextEditingController resultDurationPercentController,
    String previousDayPercentTitle = '',
    required TextEditingController prevDayTotalPercentController,
    required TextEditingController prevDayTotalController,
    this.position = ToastGravity.CENTER,
  })  : _resultDurationTitle = resultDurationTitle,
        _transferDataMap = transferDataMap,
        _resultDurationController = resultDurationController,
        _resultDurationPercentController = resultDurationPercentController,
        _previousDayPercentTitle = previousDayPercentTitle,
        _prevDayTotalPercentController = prevDayTotalPercentController,
        _prevDayTotalController = prevDayTotalController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  _resultDurationTitle,
                  style: labelTextStyle,
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              SizedBox(
                width: 140,
                child: Text(
                  _previousDayPercentTitle,
                  style: labelTextStyle,
                ),
              ),
            ],
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
                    // HitTestBehavior intercepts all pointer calls. Required,
                    // otherwise GestureDetector.onTap:, onDoubleTap:,
                    // onLongPress: not applied
                    behavior: HitTestBehavior.opaque,

                    child: IgnorePointer(
                      child: TextField(
                        style: valueTextStyle,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        keyboardType: TextInputType.datetime,
                        controller: _resultDurationController,
                        readOnly: true,
                      ),
                    ),
                    onDoubleTap: () async {
                      await copyToClipboard(
                          context: context,
                          controller: _resultDurationController,
                          position: position);
                      _transferDataMap['clipboardLastAction'] =
                          ClipboardLastAction.copy;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 60,
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
                    // HitTestBehavior intercepts all pointer calls. Required,
                    // otherwise GestureDetector.onTap:, onDoubleTap:,
                    // onLongPress: not applied
                    behavior: HitTestBehavior.opaque,

                    child: IgnorePointer(
                      child: TextField(
                        style: valueTextStyle,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        keyboardType: TextInputType.datetime,
                        controller: _resultDurationPercentController,
                        readOnly: true,
                      ),
                    ),
                    onDoubleTap: () async {
                      await copyToClipboard(
                          context: context,
                          controller: _resultDurationPercentController,
                          position: position);
                      _transferDataMap['clipboardLastAction'] =
                          ClipboardLastAction.copy;
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              SizedBox(
                width: 70,
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
                    // HitTestBehavior intercepts all pointer calls. Required,
                    // otherwise GestureDetector.onTap:, onDoubleTap:,
                    // onLongPress: not applied
                    behavior: HitTestBehavior.opaque,

                    child: IgnorePointer(
                      child: TextField(
                        style: valueTextStyle,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        keyboardType: TextInputType.datetime,
                        controller: _prevDayTotalPercentController,
                        readOnly: true,
                      ),
                    ),
                    onDoubleTap: () async {
                      await copyToClipboard(
                          context: context,
                          controller: _prevDayTotalPercentController,
                          position: position);
                      _transferDataMap['clipboardLastAction'] =
                          ClipboardLastAction.copy;
                    },
                  ),
                ),
              ),
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
                    // HitTestBehavior intercepts all pointer calls. Required,
                    // otherwise GestureDetector.onTap:, onDoubleTap:,
                    // onLongPress: not applied
                    behavior: HitTestBehavior.opaque,

                    child: IgnorePointer(
                      child: TextField(
                        style: valueTextStyle,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        keyboardType: TextInputType.datetime,
                        controller: _prevDayTotalController,
                        readOnly: true,
                      ),
                    ),
                    onDoubleTap: () async {
                      await copyToClipboard(
                          context: context,
                          controller: _prevDayTotalController,
                          position: position);
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
