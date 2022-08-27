import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// Widget enabling to add or subtract a HH:MM value to the
/// duration field.
class EditableDurationPercent extends StatefulWidget with ScreenMixin {
  final String _dateTimeTitle;
  final TextEditingController _durationTextFieldController;
  final TextEditingController _addTimeTextFieldController;
  final TextEditingController _addTimeDialogController;
  final TextEditingController _finalDurationTextFieldController;
  final Function _addPosOrNegTimeToCurrentDuration;
  final Function _deleteAddedTimeDuration;
  final double topSelMenuPosition;

  EditableDurationPercent({
    required String dateTimeTitle,
    required TextEditingController durationTextFieldController,
    required TextEditingController addTimeTextFieldController,
    required TextEditingController addTimeDialogController,
    required TextEditingController finalDurationTextFieldController,
    required Function addPosOrNegTimeToCurrentDurationFunction,
    required Function deleteAddedTimeDurationFunction,
    required this.topSelMenuPosition,
  })  : _dateTimeTitle = dateTimeTitle,
        _durationTextFieldController = durationTextFieldController,
        _addTimeTextFieldController = addTimeTextFieldController,
        _addTimeDialogController = addTimeDialogController,
        _finalDurationTextFieldController = finalDurationTextFieldController,
        _addPosOrNegTimeToCurrentDuration =
            addPosOrNegTimeToCurrentDurationFunction,
        _deleteAddedTimeDuration = deleteAddedTimeDurationFunction;

  @override
  State<EditableDurationPercent> createState() =>
      _EditableDurationPercentState();
}

class _EditableDurationPercentState extends State<EditableDurationPercent> {
  Future<String?> openTextInputDialog({required BuildContext context}) {
    void submit() {
      Navigator.of(context).pop(widget._addTimeDialogController.text);

      widget._addTimeDialogController.clear();
    }

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time to add'),
        content: TextField(
          autofocus: true,
          style: const TextStyle(
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
          decoration: const InputDecoration(hintText: '(-)HH:mm'),
          controller: widget._addTimeDialogController,
          onSubmitted: (_) => submit(),
          keyboardType: TextInputType.datetime,
        ),
        actions: [
          TextButton(
            child: const Text('Add time'),
            onPressed: submit,
          ),
        ],
      ),
    );
  }

  void handleSelectedPercentStr(String percentStr) {
    print(percentStr);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget._dateTimeTitle,
              style: widget.labelTextStyle,
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
                        selectionColor: widget.selectionColor,
                        cursorColor: ScreenMixin.appTextAndIconColor,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: const TextStyle(
                            color: ScreenMixin.appTextAndIconColor,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: widget._durationTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await widget.copyToClipboard(
                            context: context,
                            controller: widget._durationTextFieldController);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 55,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: widget.selectionColor,
                        cursorColor: ScreenMixin.appTextAndIconColor,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: const TextStyle(
                            color: ScreenMixin.appTextAndIconColor,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: widget._addTimeTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await widget.copyToClipboard(
                            context: context,
                            controller: widget._addTimeTextFieldController);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 55,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: widget.selectionColor,
                        cursorColor: ScreenMixin.appTextAndIconColor,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: const TextStyle(
                            color: ScreenMixin.appTextAndIconColor,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: widget._finalDurationTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await widget.copyToClipboard(
                            context: context,
                            controller:
                                widget._finalDurationTextFieldController);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kVerticalFieldDistance, //  required for correct
              //                       Del and Sel buttons positioning.
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: widget.appElevatedButtonBackgroundColor,
                  shape: widget.appElevatedButtonRoundedShape),
              onPressed: () async {
                final timeStr = await openTextInputDialog(
                  context: context,
                );
                if (timeStr == null || timeStr.isEmpty) return;

                widget._addPosOrNegTimeToCurrentDuration(context, timeStr);
              },
              child: const Text(
                'Del',
                style: TextStyle(
                  fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: widget.appElevatedButtonBackgroundColor,
                  shape: widget.appElevatedButtonRoundedShape),
              onPressed: () {
                widget.displaySelPopupMenu(
                  context: context,
                  selectableStrItemLst: [
                    '40 %',
                    '50 %',
                    '60 %',
                    '70 %',
                    '80 %',
                    '90 %',
                  ],
                  posRectangleLTRB: RelativeRect.fromLTRB(
                    1.0,
                    widget.topSelMenuPosition,
                    0.0,
                    0.0,
                  ),
                  handleSelectedItem: handleSelectedPercentStr,
                );
              },
              child: const Text(
                'Sel',
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
