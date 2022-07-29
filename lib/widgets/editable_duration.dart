import 'package:circa_plan/widgets/circadian_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/services.dart';

class EditableDuration extends StatelessWidget with ScreenMixin {
  final String _dateTimeTitle;
  final TextEditingController _durationTextFieldController;
  final TextEditingController _addTimeTextFieldController;
  final TextEditingController _addTimeDialogController;
  final TextEditingController _finalDurationTextFieldController;
  final Function _addPosOrNegTimeToCurrentDuration;
  final Function _deleteAddedTimeDuration;

  EditableDuration({
    required String dateTimeTitle,
    required TextEditingController durationTextFieldController,
    required TextEditingController addTimeTextFieldController,
    required TextEditingController addTimeDialogController,
    required TextEditingController finalDurationTextFieldController,
    required Function addPosOrNegTimeToCurrentDurationFunction,
    required Function deleteAddedTimeDurationFunction,
  })  : _dateTimeTitle = dateTimeTitle,
        _durationTextFieldController = durationTextFieldController,
        _addTimeTextFieldController = addTimeTextFieldController,
        _addTimeDialogController = addTimeDialogController,
        _finalDurationTextFieldController = finalDurationTextFieldController,
        _addPosOrNegTimeToCurrentDuration =
            addPosOrNegTimeToCurrentDurationFunction,
        _deleteAddedTimeDuration = deleteAddedTimeDurationFunction;

  Future<String?> openTextInputDialog({required BuildContext context}) {
    void submit() {
      Navigator.of(context).pop(_addTimeDialogController.text);

      _addTimeDialogController.clear();
    }

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time to add'),
        content: TextField(
          autofocus: true,
          style: TextStyle(
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
          decoration: const InputDecoration(hintText: '(-)HH:mm'),
          controller: _addTimeDialogController,
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
              style: TextStyle(
                color: appLabelColor,
                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
              ),
            ),
            const SizedBox(
              height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
            ),
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    width: 55,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: TextStyle(
                            color: appTextAndIconColor,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: _durationTextFieldController,
                        onTap: () async {
                          _durationTextFieldController.selection =
                              TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _durationTextFieldController
                                      .value.text.length);
                          await Clipboard.setData(ClipboardData(
                              text: _durationTextFieldController.text));
                          final CircadianSnackBar snackBar = CircadianSnackBar(
                              message:
                                  '${_durationTextFieldController.text} copied to clipboard');
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        readOnly: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 55,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: TextStyle(
                            color: appTextAndIconColor,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: _addTimeTextFieldController,
                        readOnly: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 55,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: TextStyle(
                            color: appTextAndIconColor,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: _finalDurationTextFieldController,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25, //  required for correct Now and Sel buttons
              //              positioning.
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
                final timeStr = await openTextInputDialog(
                  context: context,
                );
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
              width: 20,
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
