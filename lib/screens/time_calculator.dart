import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

import '../utils/utility.dart';
import '../widgets/editable_duration_percent.dart';

class TimeCalculator extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  final TransferDataViewModel _transferDataViewModel;

  const TimeCalculator({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
    required TransferDataViewModel transferDataViewModel,
  })  : _screenNavigTransData = screenNavigTransData,
        _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  _TimeCalculatorState createState() {
    return _TimeCalculatorState(
        transferDataMap: _screenNavigTransData.transferDataMap,
        transferDataViewModel: _transferDataViewModel);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _TimeCalculatorState extends State<TimeCalculator> with ScreenMixin {
  _TimeCalculatorState(
      {required Map<String, dynamic> transferDataMap,
      required TransferDataViewModel transferDataViewModel})
      : _transferDataMap = transferDataMap,
        _transferDataViewModel = transferDataViewModel,
        _firstTimeStr = transferDataMap['firstTimeStr'] ?? '00:00:00',
        _secondTimeStr = transferDataMap['secondTimeStr'] ?? '00:00:00',
        _resultTimeStr = transferDataMap['resultTimeStr'] ?? '',
        _divideFirstBySecond =
            transferDataMap['divideFirstBySecondCheckBox'] ?? false,
        super();

  static const double LARGER_BUTTON_WIDTH = 82.0;

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _firstTimeStr = '';
  String _secondTimeStr = '';
  String _resultTimeStr = '';

  late TextEditingController _firstTimeTextFieldController;
  late TextEditingController _secondTimeTextFieldController;
  late TextEditingController _resultTextFieldController;

  late EditableDurationPercent _editableDurationPercentWidgetFirst;
  late EditableDurationPercent _editableDurationPercentWidgetSecond;

  bool _divideFirstBySecond = false;

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data are
  /// displayed. Calling this method is necessary since the load function
  /// is performed after selecting a item in a menu displayed by the AppBar
  /// menu defined not by the current screen, but by the main app screen.
  ///
  /// The method is called when the _MainAppState.handleSelectedLoadFileName()
  /// method is executed after the file to load has been selected in the
  /// AppBar load ... sub menu.
  void callSetState() {
    _updateWidgets();

    String extractedHHmm = '';

    if (_resultTimeStr.isNotEmpty) {
      // _resultTimeStr is empty in case the app is launched
      // after deleting all json files.
      extractedHHmm = _extractHHmm(_resultTimeStr);
    }

    // Re-enabling the next two lines of code no longer prevent
    // Undo to work since _editableDurationPercentWidget line
    // 145 has been commented out !
    _editableDurationPercentWidgetFirst.setDurationStr(extractedHHmm);
    _editableDurationPercentWidgetFirst.callSetState();

    _editableDurationPercentWidgetSecond.setDurationStr(extractedHHmm);
    _editableDurationPercentWidgetSecond.callSetState();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // The reference to the stateful widget State instance stored in
    // the transfer data map is used in the
    // _MainAppState.handleSelectedLoadFileName() method executed after
    // the file to load has been selected in the AppBar load ... sub menu
    // in order to call the current instance callSetState() method.
    _transferDataMap['currentScreenStateInstance'] = this;

    _updateWidgets();

    String extractedHHmm = '';

    // The next instruction enables updating result % value
    // when going back to the time calculator screen.
    // As a consequence, the result % value does not need to
    // be stored in the transfer data map !
    if (_resultTimeStr.isNotEmpty) {
      // _resultTimeStr is empty in case the app is launched
      // after deleting all json files.
      extractedHHmm = _extractHHmm(_resultTimeStr);
    }

    _editableDurationPercentWidgetFirst = EditableDurationPercent(
      dateTimeTitle: 'Result %',
      transferDataMapPercentKey: 'resultPercentStr',
      durationStr: extractedHHmm,
      topSelMenuPosition: 343.0,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
    );

    _editableDurationPercentWidgetSecond = EditableDurationPercent(
      dateTimeTitle: 'Result %',
      transferDataMapPercentKey: 'resultSecondPercentStr',
      durationStr: extractedHHmm,
      topSelMenuPosition: 411.0,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
    );
  }

  /// For example, extract '263:00' from '10:23:00 = 263:00' or
  /// '-103:00' ftom '-04:07:00 = -103:00' or '-2:00' from
  /// '-00:02:00 = -2:00'.
  String _extractHHmm(String ddHHmmStr) {
    RegExp regExp = RegExp(r'(\-?)(\d+:\d+)$');

    RegExpMatch? firstMatch = regExp.firstMatch(ddHHmmStr);

    if (firstMatch == null) {
      return '';
    }

    String sign = firstMatch.group(1) ?? '';
    String value = firstMatch.group(2) ?? '';

    return '$sign$value';
  }

  void _updateWidgets() {
    _firstTimeStr = _transferDataMap['firstTimeStr'] ?? '00:00:00';
    _firstTimeTextFieldController = TextEditingController(text: _firstTimeStr);
    _secondTimeStr = _transferDataMap['secondTimeStr'] ?? '00:00:00';
    _secondTimeTextFieldController =
        TextEditingController(text: _secondTimeStr);
    _resultTimeStr = _transferDataMap['resultTimeStr'] ?? '';
    _resultTextFieldController = TextEditingController(text: _resultTimeStr);
    _divideFirstBySecond =
        _transferDataMap['divideFirstBySecondCheckBox'] ?? false;

    // fixed Undo bug: after Add or Subtr button pressed,
    // now Undo works. I don't know why, but this solution
    // is no longer necessary !!!
    //
    // in fact, the next expression raises this exception:
    //
    // Exception has occurred.
    // LateError (LateInitializationError: Field '_editableDurationPercentWidget@37463065'
    // has not been initialized.)
    //
    // _editableDurationPercentWidget.setDurationStr(_resultTimeStr);
  }

  @override
  void dispose() {
    _firstTimeTextFieldController.dispose();
    _secondTimeTextFieldController.dispose();
    _resultTextFieldController.dispose();

    if (_transferDataMap['currentScreenStateInstance'] == this) {
      _transferDataMap['currentScreenStateInstance'] = null;
    }

    super.dispose();
  }

  void _updateTransferDataMap() {
    _transferDataMap['firstTimeStr'] = _firstTimeStr;
    _transferDataMap['secondTimeStr'] = _secondTimeStr;
    _transferDataMap['resultTimeStr'] = _resultTimeStr;
    _transferDataMap['divideFirstBySecondCheckBox'] = _divideFirstBySecond;

    _transferDataViewModel.updateAndSaveTransferData();
  }

  void _resetScreen() {
    _firstTimeStr = '00:00:00';
    _firstTimeTextFieldController.text = _firstTimeStr;
    _secondTimeStr = '00:00:00';
    _secondTimeTextFieldController.text = _secondTimeStr;
    _resultTimeStr = '';
    _resultTextFieldController.text = _resultTimeStr;
    _editableDurationPercentWidgetFirst.setDurationStr(_resultTimeStr);
    _editableDurationPercentWidgetSecond.setDurationStr(_resultTimeStr);
    _divideFirstBySecond = false;

    setState(() {});

    _updateTransferDataMap();
  }

  void _addSubtractTimeDuration(
      {required BuildContext context, required bool isPlus}) {
    /// Private method called when pressing the 'Plus' or 'Minus' buttons.
    _firstTimeStr = _firstTimeTextFieldController.text;
    _secondTimeStr = _secondTimeTextFieldController.text;
    Duration? firstTimeDuration =
        DateTimeParser.parseDDHHMMorHHMMDuration(_firstTimeStr);
    Duration? secondTimeDuration =
        DateTimeParser.parseDDHHMMorHHMMDuration(_secondTimeStr);

    Duration resultDuration;
    String warningMsg;

    if (firstTimeDuration == null) {
      if (isPlus) {
        warningMsg =
            'You are trying to add time to an incorrectly formated dd:hh:mm time $_firstTimeStr. Please correct it and retry !';
      } else {
        warningMsg =
            'You are trying to subtract time from an incorrectly formated dd:hh:mm time $_firstTimeStr. Please correct it and retry !';
      }

      openWarningDialog(context, warningMsg);

      return;
    }

    if (secondTimeDuration == null) {
      if (isPlus) {
        warningMsg =
            'You are trying to add an incorrectly formated dd:hh:mm time $_secondTimeStr to $_firstTimeStr. Please correct it and retry !';
      } else {
        warningMsg =
            'You are trying to subtract an incorrectly formated dd:hh:mm time $_secondTimeStr from $_firstTimeStr. Please correct it and retry !';
      }

      openWarningDialog(context, warningMsg);

      return;
    }

    if (isPlus) {
      resultDuration = firstTimeDuration + secondTimeDuration;
    } else {
      resultDuration = firstTimeDuration - secondTimeDuration;
    }

    String resultTimeStr;

    _resultTimeStr = '${resultDuration.ddHHmm()} = ${resultDuration.HHmm()}';
    _resultTextFieldController.text = _resultTimeStr;

    String extractedHHmm = _extractHHmm(_resultTimeStr);

    _editableDurationPercentWidgetFirst.setDurationStr(extractedHHmm);
    _editableDurationPercentWidgetSecond.setDurationStr(extractedHHmm);

    setState(() {});

    _updateTransferDataMap();
  }

  void _divMultTimeDuration(
      {required BuildContext context, required bool isDiv}) {
    /// Private method called when pressing the 'Plus' or 'Minus' buttons.
    _firstTimeStr = _firstTimeTextFieldController.text;
    _secondTimeStr = _secondTimeTextFieldController.text;
    Duration? firstTimeDuration =
        DateTimeParser.parseDDHHMMorHHMMDuration(_firstTimeStr);
    Duration? secondTimeDuration =
        DateTimeParser.parseDDHHMMorHHMMDuration(_secondTimeStr);

    Duration resultDuration;
    String? warningMsg;

    if (firstTimeDuration == null) {
      if (isDiv) {
        warningMsg =
            'You are trying to divide an incorrectly formated dd:hh:mm time $_firstTimeStr. Please correct it and retry !';
      } else {
        warningMsg =
            'You are trying to % multiply an incorrectly formated dd:hh:mm time $_firstTimeStr. Please correct it and retry !';
      }

      openWarningDialog(context, warningMsg);

      return;
    }

    double percentValue = 0.0;

    if (secondTimeDuration == null) {
      if (isDiv) {
        warningMsg =
            'You are trying to divide $_firstTimeStr by an incorrectly formated dd:hh:mm time $_secondTimeStr. Please correct it and retry !';
      } else {
        RegExp doubleRE = RegExp(r"-?(?:\d*\.)?\d+");
        RegExpMatch? firstMatch = doubleRE.firstMatch(_secondTimeStr);
        if (firstMatch != null) {
          percentValue = double.parse(firstMatch.group(0)!);
        } else {
          warningMsg =
              'You are trying to % multiply $_firstTimeStr by an incorrectly formated % value $_secondTimeStr. Please correct it and retry !';
        }
      }

      if (warningMsg != null) {
        openWarningDialog(context, warningMsg);

        return;
      }
    } else {
      // secondTimeDuration is not null
      if (_secondTimeStr.contains('%')) {
        warningMsg =
            'Invalid second time or % value format $_secondTimeStr. Please correct it and retry !';
        openWarningDialog(context, warningMsg);

        return;
      }

      if (!isDiv) {
        warningMsg =
            'Invalid % value format $_secondTimeStr. Please correct it and retry !';
        openWarningDialog(context, warningMsg);

        return;
      }
    }

    double divisionResult = 0.0;

    if (isDiv) {
      if (_divideFirstBySecond) {
        // if the divideFirstBySecond checkbox is checked, the
        // greater time is divided by the smaller time
        if (firstTimeDuration.inMicroseconds <
            secondTimeDuration!.inMicroseconds) {
          divisionResult = (secondTimeDuration.inMicroseconds /
              firstTimeDuration.inMicroseconds *
              100);
        } else {
          divisionResult = (firstTimeDuration.inMicroseconds /
              secondTimeDuration.inMicroseconds *
              100);
        }
      } else {
        // the smaller time is divided by the greater time since
        // doing the contrary is less useful in the Circadian app !
        if (firstTimeDuration.inMicroseconds >
            secondTimeDuration!.inMicroseconds) {
          divisionResult = (secondTimeDuration.inMicroseconds /
              firstTimeDuration.inMicroseconds *
              100);
        } else {
          divisionResult = (firstTimeDuration.inMicroseconds /
              secondTimeDuration.inMicroseconds *
              100);
        }
      }
      _resultTimeStr = '${divisionResult.toStringAsFixed(2)} %';
    } else {
      // here, % multiplication
      _divideFirstBySecond = false; // deactivating the checkbox
      //                whose value has no sense in this context !
      resultDuration = Duration(
          microseconds:
              (firstTimeDuration.inMicroseconds * percentValue / 100).round());
      _resultTimeStr = '${resultDuration.ddHHmm()} = ${resultDuration.HHmm()}';
    }

    _resultTextFieldController.text = _resultTimeStr;

    String extractedHHmm = _extractHHmm(_resultTimeStr);

    _editableDurationPercentWidgetFirst.setDurationStr(extractedHHmm);
    _editableDurationPercentWidgetSecond.setDurationStr(extractedHHmm);

    setState(() {});

    _updateTransferDataMap();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: ScreenMixin.app_computed_vertical_top_margin),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Time (dd:hh:mm)',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0), // val 4 is
//                                            compliant with current value 6 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        ),
                      ),
                      child: GestureDetector(
                        child: TextField(
                          key: const Key('firstTimeTextField'),
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: valueTextStyle,
                          keyboardType: TextInputType.datetime,
                          controller: _firstTimeTextFieldController,
                          onSubmitted: (val) {
                            // called when manually updating the TextField
                            // content. onChanged must be defined in order for
                            // pasting a value to the TextField to really
                            // modify the TextField value and store it
                            // in the screen navigation transfer
                            // data map.
                            _firstTimeStr = Utility.convertIntDuration(
                                durationStr: val, dayHourMinuteFormat: true);
                            _firstTimeTextFieldController.text = _firstTimeStr;
                            setState(() {});
                            _updateTransferDataMap();
                          },
                        ),
                        onDoubleTap: () async {
                          await handleClipboardDataEditableDuration(
                              context: context,
                              textEditingController:
                                  _firstTimeTextFieldController,
                              transferDataMap: _transferDataMap,
                              handleDataChangeFunc:
                                  (BuildContext c, String s) {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
                  ),
                  Text(
                    'Time (dd:hh:mm|%)',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0), // val 4 is
//                                            compliant with current value 6 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        ),
                      ),
                      child: GestureDetector(
                        child: TextField(
                          key: const Key('secondTimeTextField'),
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: valueTextStyle,
                          keyboardType: TextInputType.datetime,
                          controller: _secondTimeTextFieldController,
                          onSubmitted: (val) {
                            // called when manually updating the TextField
                            // content. onChanged must be defined in order for
                            // pasting a value to the TextField to really
                            // modify the TextField value and store it
                            // in the screen navigation transfer
                            // data map.
                            _secondTimeStr = Utility.convertIntDuration(
                                durationStr: val, dayHourMinuteFormat: true);
                            _secondTimeTextFieldController.text =
                                _secondTimeStr;
                            setState(() {});
                            _updateTransferDataMap();
                          },
                        ),
                        onDoubleTap: () async {
                          await handleClipboardDataEditableDuration(
                              context: context,
                              textEditingController:
                                  _secondTimeTextFieldController,
                              transferDataMap: _transferDataMap,
                              handleDataChangeFunc:
                                  (BuildContext c, String s) {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
                  ),
                  Text(
                    'Result',
                    style: labelTextStyle,
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
                        // cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        key: const Key('resultTextField'),
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: valueTextStyle,
                        // The validator receives the text that the user has entered.
                        controller: _resultTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await handleClipboardDataEditableDuration(
                            context: context,
                            textEditingController: _resultTextFieldController,
                            transferDataMap: _transferDataMap,
                            handleDataChangeFunc:
                                (BuildContext c, String s) {});
                      },
                    ),
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
                  ),
                  _editableDurationPercentWidgetFirst,
                  _editableDurationPercentWidgetSecond,
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Column(
                children: [
                  const SizedBox(
                    height: 78,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 46,
                      ),
                      ElevatedButton(
                        key: const Key('addButton'),
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          _addSubtractTimeDuration(
                              context: context, isPlus: true);
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
                      SizedBox(
                        width: _TimeCalculatorState.LARGER_BUTTON_WIDTH,
                        child: ElevatedButton(
                          key: const Key('subtractButton'),
                          style: ButtonStyle(
                              backgroundColor: appElevatedButtonBackgroundColor,
                              shape: appElevatedButtonRoundedShape),
                          onPressed: () {
                            _addSubtractTimeDuration(
                                context: context, isPlus: false);
                          },
                          child: const Text(
                            'Subtr',
                            style: TextStyle(
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.white70,
                        ),
                        child: Checkbox(
                          key: const Key('divideFirstBySecond'),
                          value: _divideFirstBySecond,
                          onChanged: (value) {
                            setState(() {
                              _divideFirstBySecond = value!;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        key: const Key('divButton'),
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          _divMultTimeDuration(context: context, isDiv: true);
                        },
                        child: const Text(
                          'Div',
                          style: TextStyle(
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: _TimeCalculatorState.LARGER_BUTTON_WIDTH,
                        child: ElevatedButton(
                          key: const Key('multButton'),
                          style: ButtonStyle(
                              backgroundColor: appElevatedButtonBackgroundColor,
                              shape: appElevatedButtonRoundedShape),
                          onPressed: () {
                            _divMultTimeDuration(
                                context: context, isDiv: false);
                          },
                          child: const Text(
                            '%Mult',
                            style: TextStyle(
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight *
                  ScreenMixin.APP_VERTICAL_TOP_RESET_BUTTON_MARGIN_PROPORTION,
            ),
            ResetButton(
              onPress: _resetScreen,
            ),
/*            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.fromLTRB(240, 404, 0, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: appElevatedButtonBackgroundColor,
                      shape: appElevatedButtonRoundedShape),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> pasteFromClipboard(
      {required TextEditingController controller}) async {
    controller.selection = TextSelection(
        baseOffset: 0, extentOffset: controller.value.text.length);
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    String copiedtext = (cdata != null) ? cdata.text ?? '' : '';
    controller.text = copiedtext;
  }
}
