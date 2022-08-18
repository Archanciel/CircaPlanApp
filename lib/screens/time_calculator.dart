import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

enum status { wakeUp, sleep }

final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

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
        super();

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _firstTimeStr = '';
  String _secondTimeStr = '';
  String _resultTimeStr = '';

  late TextEditingController _firstTimeTextFieldController;
  late TextEditingController _secondTimeTextFieldController;
  late TextEditingController _resultTextFieldController;

  final DateFormat _frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  void callSetState() {
    _updateWidgets();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _transferDataMap['currentScreenState'] = this;

    _updateWidgets();
  }

  void _updateWidgets() {
    _firstTimeTextFieldController = TextEditingController(
        text: _transferDataMap['firstTimeStr'] ?? '00:00:00');
    _secondTimeTextFieldController = TextEditingController(
        text: _transferDataMap['secondTimeStr'] ?? '00:00:00');
    _resultTextFieldController =
        TextEditingController(text: _transferDataMap['resultTimeStr'] ?? '');
    _resultTimeStr = _transferDataMap['resultTimeStr'] ?? '';
  }

  @override
  void dispose() {
    _firstTimeTextFieldController.dispose();
    _secondTimeTextFieldController.dispose();
    _resultTextFieldController.dispose();

    if (_transferDataMap['currentScreenState'] == this) {
      _transferDataMap['currentScreenState'] = null;
    }

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['firstTimeStr'] = _firstTimeStr;
    map['secondTimeStr'] = _secondTimeStr;
    map['resultTimeStr'] = _resultTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();

    return map;
  }

  void _resetScreen() {
    _firstTimeStr = '00:00:00';
    _firstTimeTextFieldController.text = _firstTimeStr;
    _secondTimeStr = '00:00:00';
    _secondTimeTextFieldController.text = _secondTimeStr;
    _resultTimeStr = '';
    _resultTextFieldController.text = _resultTimeStr;

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

    if (firstTimeDuration == null) {
      openWarningDialog(context,
          'You are trying to add/subtract time to an incorrectly formated dd:hh:mm time ($_firstTimeStr). Please correct it and retry !');
      return;
    }

    if (secondTimeDuration == null) {
      openWarningDialog(context,
          'You are trying to add/subtract an incorrectly formated dd:hh:mm time ($_secondTimeStr). Please correct it and retry !');
      return;
    }

    if (isPlus) {
      resultDuration = firstTimeDuration + secondTimeDuration;
    } else {
      resultDuration = firstTimeDuration - secondTimeDuration;
    }

    String resultTimeStr;

    if (resultDuration.inDays > 0) {
      resultTimeStr = '${resultDuration.ddHHmm()} = ${resultDuration.HHmm()}';
    } else {
      resultTimeStr = '${resultDuration.ddHHmm()}';
    }

    _resultTimeStr = resultTimeStr;
    _resultTextFieldController.text = resultTimeStr;

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
                          cursorColor: ScreenMixin.appTextAndIconColor,
                        ),
                      ),
                      child: GestureDetector(
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: valueTextStyle,
                          keyboardType: TextInputType.datetime,
                          controller: _firstTimeTextFieldController,
                          onChanged: (val) {
                            // called when manually updating the TextField
                            // content. onChanged must be defined in order for
                            // pasting a value to the TextField to really
                            // modify the TextField value and store it
                            // in the screen navigation transfer
                            // data map.
                            _firstTimeStr = val;
                            _updateTransferDataMap();
                          },
                        ),
                        onDoubleTap: () async {
                          await pasteFromClipboard(
                            controller: _firstTimeTextFieldController,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
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
                          cursorColor: ScreenMixin.appTextAndIconColor,
                        ),
                      ),
                      child: GestureDetector(
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: valueTextStyle,
                          keyboardType: TextInputType.datetime,
                          controller: _secondTimeTextFieldController,
                          onChanged: (val) {
                            // called when manually updating the TextField
                            // content. onChanged must be defined in order for
                            // pasting a value to the TextField to really
                            // modify the TextField value and store it
                            // in the screen navigation transfer
                            // data map.
                            _secondTimeStr = val;
                            _updateTransferDataMap();
                          },
                        ),
                        onDoubleTap: () async {
                          await pasteFromClipboard(
                            controller: _secondTimeTextFieldController,
                          );
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
                        // cursorColor: ScreenMixin.appTextAndIconColor,
                      ),
                    ),
                    child: GestureDetector(
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: valueTextStyle,
                        // The validator receives the text that the user has entered.
                        controller: _resultTextFieldController,
                        readOnly: true,
                      ),
                      onDoubleTap: () async {
                        await copyToClipboard(
                            context: context,
                            controller: _resultTextFieldController);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 96, // val 97 is compliant with current value 6
//                                 of APP_LABEL_TO_TEXT_DISTANCE
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          //  _startDateTimeController.text = DateTime.now().toString();
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
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          //  _startDateTimeController.text = DateTime.now().toString();
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
