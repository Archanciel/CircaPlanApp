import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

import '../buslog/transfer_data_view_model.dart';

/// Widget enabling to select and compute a duration percent value.
class EditableDurationPercent extends StatefulWidget with ScreenMixin {
  final String _dateTimeTitle;
  final String transferDataMapPercentKey;
  final TextEditingController durationPercentTextFieldController =
      TextEditingController();
  final TextEditingController selectedPercentTextFieldController =
      TextEditingController();
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

  /// transferDataMapPercentKey: since the EditableDurationPercent
  /// widget is included in different screens, it is necessary to
  /// store the percent string value with a key specific to the
  /// concerned EditableDurationPercent widget instance.
  EditableDurationPercent({
    required String dateTimeTitle,
    required this.transferDataMapPercentKey,
    required this.durationStr,
    required this.topSelMenuPosition,
    required this.transferDataViewModel,
    required this.transferDataMap,
  }) : _dateTimeTitle = dateTimeTitle;

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data to be
  /// displayed. Calling this method is necessary since the load function
  /// menu defined not by the current screen, but by the main app screen.
  /// is performed after selecting a item in a menu displayed by the AppBar
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
        transferDataMap[transferDataMapPercentKey] ?? '100 %');
  }

  @override
  State<EditableDurationPercent> createState() {
    stateInstance = _EditableDurationPercentState();

    return stateInstance;
  }
}

class _EditableDurationPercentState extends State<EditableDurationPercent> {
  void handleSelectedPercentStr(String percentStr) {
    widget.selectedPercentTextFieldController.text = percentStr;

    if (percentStr.isEmpty) {
      // the case if clicked on Reset button after clicked on Del
      // button !
      return;
    }

    double percentValueDouble = 0.0;

    try {
      percentValueDouble = double.parse(percentStr.replaceFirst(' %', ''));
    } catch (e) {
      // in case the user enter a non double parsable percent
      // value, the invalid value is replaced by 0 % !
      widget.selectedPercentTextFieldController.text = '0 %';
    }

    Duration? duration = DateTimeParser.parseHHmmDuration(widget.durationStr);
    String percentDurationStr = '';

    if (duration != null) {
      // is null after clicking on Reset button !
      int percentDurationMicrosecondsInt =
          (duration.inMicroseconds * percentValueDouble / 100).round();
      Duration percentDuration =
          Duration(microseconds: percentDurationMicrosecondsInt);
      percentDurationStr = percentDuration.HHmm();
    }

    _updateDurationPercentStr(
      percentStr: percentStr,
      percentDurationStr: percentDurationStr,
    );
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
        widget.transferDataMap[widget.transferDataMapPercentKey] ?? '100 %';

    handleSelectedPercentStr(percentStr);

    setState(() {});
  }

  void _deleteDurationPercent() {
    widget.selectedPercentTextFieldController.text = '';
    _updateDurationPercentStr(
      percentStr: '',
      percentDurationStr: '',
    );
  }

  void _updateDurationPercentStr({
    required String percentStr,
    required String percentDurationStr,
  }) {
    widget.durationPercentTextFieldController.text = percentDurationStr;
    widget.transferDataMap[widget.transferDataMapPercentKey] = percentStr;

    // Commenting out last method line avoids making Redo (Undo +
    // Undo !) not working.
    //
    // But it also prevents saving the changed percent value
    // unless after changing the percent value Undo and Redo were
    // done or start or end date time were changed, which caused
    // DateTimeDifferenceDuration screen to call
    // transferDataViewModel.updateAndSaveTransferData() or another
    // screen was selected !!!
    //
    // widget.transferDataViewModel.updateAndSaveTransferData();
  }

  @override
  void initState() {
    super.initState();

    String? percentStrValue =
        widget.transferDataMap[widget.transferDataMapPercentKey];

    if (percentStrValue == null) {
      // the case if the app is launched after deleting all json
      // files.
      return;
    }

    handleSelectedPercentStr(percentStrValue);
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
              key: const Key('edpTitleText'),
              widget._dateTimeTitle,
              style: widget.labelTextStyle,
            ),
            const SizedBox(
              height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: widget.selectionColor,
                        cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        key: const Key(
                            'edpDurationPercentComputedValueTextField'),
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: const TextStyle(
                            color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
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
                        widget.transferDataMap['clipboardLastAction'] =
                            ClipboardLastAction.copy;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: widget.selectionColor,
                        cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        key: const Key('edpDurationPercentTextField'),
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: const TextStyle(
                            color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                        controller: widget.selectedPercentTextFieldController,
                        readOnly: false,
                        onSubmitted: (val) {
                          // called when manually updating the TextField
                          // content. onChanged must be defined in order for
                          // pasting a value to the TextField to really
                          // modify the TextField value and store it
                          // in the screen navigation transfer
                          // data map.

                          if (!val.contains('%')) {
                            val = '$val %';
                          }

                          handleSelectedPercentStr(val);
                          setState(() {});
                        },
                      ),
                      onDoubleTap: () async {
                        await widget.copyToClipboard(
                            context: context,
                            controller:
                                widget.selectedPercentTextFieldController);
                        widget.transferDataMap['clipboardLastAction'] =
                            ClipboardLastAction.copy;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
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
              key: const Key('edpDelButton'),
              style: ButtonStyle(
                  backgroundColor: widget.appElevatedButtonBackgroundColor,
                  shape: widget.appElevatedButtonRoundedShape),
              onPressed: () {
                _deleteDurationPercent();

                setState(() {});
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
              key: const Key('edpSelButton'),
              style: ButtonStyle(
                  backgroundColor: widget.appElevatedButtonBackgroundColor,
                  shape: widget.appElevatedButtonRoundedShape),
              onPressed: () {
                widget.displayPopupMenu(
                  context: context,
                  selectableStrItemLst: [
                    '40 %',
                    '45 %',
                    '50 %',
                    '55 %',
                    '60 %',
                    '65 %',
                    '70 %',
                    '75 %',
                    '80 %',
                    '85 %',
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
