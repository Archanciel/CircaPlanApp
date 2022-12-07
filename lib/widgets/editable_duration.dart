import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Widget enabling to add or subtract a HH:MM value to the
/// duration field.
class EditableDuration extends StatelessWidget with ScreenMixin {
  final String _dateTimeTitle;
  final TextEditingController _durationTextFieldController;
  final TextEditingController _addTimeTextFieldController;
  final TextEditingController _addTimeDialogController;
  final TextEditingController _finalDurationTextFieldController;
  final void Function(BuildContext context, String dialogTimeStr)
      _addPosOrNegTimeToCurrentDuration;
  final Function _deleteAddedTimeDuration;
  final Map<String, dynamic> _transferDataMap;
  final ToastGravity position;

  EditableDuration({
    required String dateTimeTitle,
    required Map<String, dynamic> transferDataMap,
    required TextEditingController durationTextFieldController,
    required TextEditingController addTimeTextFieldController,
    required TextEditingController addTimeDialogController,
    required TextEditingController finalDurationTextFieldController,
    required void Function(BuildContext context, String dialogTimeStr)
        addPosOrNegTimeToCurrentDurationFunction,
    required Function deleteAddedTimeDurationFunction,
    this.position = ToastGravity.CENTER,
  })  : _dateTimeTitle = dateTimeTitle,
        _transferDataMap = transferDataMap,
        _durationTextFieldController = durationTextFieldController,
        _addTimeTextFieldController = addTimeTextFieldController,
        _addTimeDialogController = addTimeDialogController,
        _finalDurationTextFieldController = finalDurationTextFieldController,
        _addPosOrNegTimeToCurrentDuration =
            addPosOrNegTimeToCurrentDurationFunction,
        _deleteAddedTimeDuration = deleteAddedTimeDurationFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dateTimeTitle,
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
                        cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                      ),
                    ),
                    child: GestureDetector(
                      // HitTestBehavior intercepts all pointer calls. Required,
                      // otherwise GestureDetector.onTap:, onDoubleTap:,
                      // onLongPress: not applied
                      behavior: HitTestBehavior.opaque,

                      // IgnorePointer required to avoid TextField selection and
                      // copy paste menu on long press
                      child: IgnorePointer(
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: const TextStyle(
                            color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
                          ),
                          controller: _durationTextFieldController,
                          readOnly: true,
                        ),
                      ),
                      onDoubleTap: () async {
                        await copyToClipboard(
                            context: context,
                            controller: _durationTextFieldController,
                            position: position);
                        _transferDataMap['clipboardLastAction'] =
                            ClipboardLastAction.copy;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 65,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: selectionColor,
                        cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                      ),
                    ),
                    child: GestureDetector(
                      // HitTestBehavior intercepts all pointer calls. Required,
                      // otherwise GestureDetector.onTap:, onDoubleTap:,
                      // onLongPress: not applied
                      behavior: HitTestBehavior.opaque,

                      // IgnorePointer required to avoid TextField selection and
                      // copy paste menu on long press
                      child: IgnorePointer(
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: const TextStyle(
                              color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                          controller: _addTimeTextFieldController,
                          readOnly: true,
                        ),
                      ),
                      onDoubleTap: () async {
                        await handleClipboardDataEditableDuration(
                            context: context,
                            textEditingController: _addTimeTextFieldController,
                            transferDataMap: _transferDataMap,
                            handleDataChangeFunction:
                                _addPosOrNegTimeToCurrentDuration,
                            position: position);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 65,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: selectionColor,
                        cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                      ),
                    ),
                    child: GestureDetector(
                      // HitTestBehavior intercepts all pointer calls. Required,
                      // otherwise GestureDetector.onTap:, onDoubleTap:,
                      // onLongPress: not applied
                      behavior: HitTestBehavior.opaque,

                      child: IgnorePointer(
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: const TextStyle(
                              color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                          controller: _finalDurationTextFieldController,
                          readOnly: true,
                        ),
                      ),
                      onDoubleTap: () async {
                        await copyToClipboard(
                            context: context,
                            controller: _finalDurationTextFieldController);
                        _transferDataMap['clipboardLastAction'] =
                            ClipboardLastAction.copy;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kVerticalFieldDistance, //  required for correct
              //                       Add and Del buttons positioning.
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () async {
                final timeStr = await openAddTimeDialog(
                    context: context,
                    addTimeController: _addTimeDialogController);
                if (timeStr == null || timeStr.isEmpty) return;

                _addPosOrNegTimeToCurrentDuration(context, timeStr);
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                ),
              ),
            ),
            const SizedBox(
              width: ScreenMixin.BUTTON_SEP_WIDTH,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () {
                _deleteAddedTimeDuration();
              },
              child: const Text(
                'Del',
                style: TextStyle(
                  fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
