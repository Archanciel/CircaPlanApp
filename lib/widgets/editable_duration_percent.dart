import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

import '../buslog/transfer_data_view_model.dart';

/// Widget enabling to add or subtract a HH:MM value to the
/// duration field.
class EditableDurationPercent extends StatefulWidget with ScreenMixin {
  final String _dateTimeTitle;
  final TextEditingController durationPercentTextFieldController =
      TextEditingController();
  final TextEditingController selectedPercentTextFieldController =
      TextEditingController();
  final TextEditingController _addTimeDialogController;
  final Function _addPosOrNegTimeToCurrentDuration;
  final Function _deleteAddedTimeDuration;
  final double topSelMenuPosition;
  String durationStr;
  final TransferDataViewModel transferDataViewModel;
  final Map<String, dynamic> transferDataMap;

  /// This variable enables the EditableDurationPercent
  /// instance to execute the callSetState() method of its
  /// _EditableDurationPercentState instance in order to
  /// redraw the widget to display the values modified by
  /// loading a json file.
  late final _EditableDurationPercentState stateInstance;

  EditableDurationPercent({
    required String dateTimeTitle,
    required this.durationStr,
    required TextEditingController addTimeTextFieldController,
    required TextEditingController addTimeDialogController,
    required Function addPosOrNegTimeToCurrentDurationFunction,
    required Function deleteAddedTimeDurationFunction,
    required this.topSelMenuPosition,
    required this.transferDataViewModel,
    required this.transferDataMap,
  })  : _dateTimeTitle = dateTimeTitle,
        _addTimeDialogController = addTimeDialogController,
        _addPosOrNegTimeToCurrentDuration =
            addPosOrNegTimeToCurrentDurationFunction,
        _deleteAddedTimeDuration = deleteAddedTimeDurationFunction;

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data to be
  /// displayed. Calling this method is necessary since the load function
  /// is performed after selecting a item in a menu displayed by the AppBar
  /// menu defined not by the current screen, but by the main app screen.
  ///
  /// The method is called when the _MainAppState.handleSelectedLoadFileName()
  /// method is executed after the file to load has been selected in the
  /// AppBar load ... sub menu.
  void callSetState() {
    stateInstance.callSetState();
  }

  /// Method called by DateTimeDifferenceDuration screen when
  /// the start or end date time value is changed, which changes
  /// the duration value.
  void setDurationStr(String changedDurationStr) {
    durationStr = changedDurationStr;

    stateInstance.handleSelectedPercentStr(
        transferDataMap['dtDurationPercentStr'] ?? '100 %');
  }

  @override
  State<EditableDurationPercent> createState() {
    stateInstance = _EditableDurationPercentState();

    return stateInstance;
  }
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
    widget.selectedPercentTextFieldController.text = percentStr;
    int percentValueInt = int.parse(percentStr.replaceFirst(' %', ''));
    Duration? duration = DateTimeParser.parseHHmmDuration(widget.durationStr);
    String percentDurationStr = '';

    if (duration != null) {
      // is null after clicking on Reset button !
      int percentDurationMicrosecondsInt =
          (duration.inMicroseconds * percentValueInt / 100).round();
      Duration percentDuration =
          Duration(microseconds: percentDurationMicrosecondsInt);
      percentDurationStr = percentDuration.HHmm();
    }

    widget.durationPercentTextFieldController.text = percentDurationStr;
    widget.transferDataMap['dtDurationPercentStr'] = percentStr;
    widget.transferDataViewModel.updateAndSaveTransferData();
  }

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data to be
  /// displayed. Calling this method is necessary since the load function
  /// is performed after selecting an item in a menu displayed by the AppBar
  /// menu defined not by the current screen, but by the main app screen.
  ///
  /// The method is called when the _MainAppState.handleSelectedLoadFileName()
  /// method is executed after the file to load has been selected in the
  /// AppBar load ... sub menu.
  void callSetState() {
    String percentStr =
        widget.transferDataMap['dtDurationPercentStr'] ?? '100 %';

    handleSelectedPercentStr(percentStr);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    handleSelectedPercentStr(widget.transferDataMap['dtDurationPercentStr']);
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
                        controller: widget.durationPercentTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await widget.copyToClipboard(
                            context: context,
                            controller:
                                widget.durationPercentTextFieldController);
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
                        controller: widget.selectedPercentTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await widget.copyToClipboard(
                            context: context,
                            controller:
                                widget.selectedPercentTextFieldController);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 55,
                  // child: Theme( // field not used currently
                  //   data: Theme.of(context).copyWith(
                  //     textSelectionTheme: TextSelectionThemeData(
                  //       selectionColor: widget.selectionColor,
                  //       cursorColor: ScreenMixin.appTextAndIconColor,
                  //     ),
                  //   ),
                  //   child: GestureDetector(
                  //     child: TextField(
                  //       decoration:
                  //           const InputDecoration.collapsed(hintText: ''),
                  //       style: const TextStyle(
                  //           color: ScreenMixin.appTextAndIconColor,
                  //           fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                  //           fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                  //       controller: widget._finalDurationTextFieldController,
                  //       readOnly: true,
                  //     ),
                  //     onDoubleTap: () async {
                  //       await widget.copyToClipboard(
                  //           context: context,
                  //           controller:
                  //               widget._finalDurationTextFieldController);
                  //     },
                  //   ),
                  // ),
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
