import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import '../buslog/transfer_data_view_model.dart';
import '../utils/utility.dart';

void main() {
  final TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kDownloadAppDir${Platform.pathSeparator}manuallySelectableTextField.json');

  final Map<String, dynamic> transferDataMap = {
    "firstDurationIconData": Icons.add,
    "firstDurationIconColor": Colors.green.shade200,
    "firstDurationSign": 1,
    "firstDurationTextColor": Colors.green.shade200,
    "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
    "firstDurationStr": "00:50",
    "firstStartDateTimeStr": "12-07-2022 16:00",
    "firstEndDateTimeStr": "12-07-2022 16:50",
    "secondDurationIconData": Icons.remove,
    "secondDurationIconColor": Colors.red.shade200,
    "secondDurationSign": -1,
    "secondDurationTextColor": Colors.red.shade200,
    "secondDurationStr": "02:00",
    "secondStartDateTimeStr": "12-07-2022 16:00",
    "secondEndDateTimeStr": "12-07-2022 14:00",
    "thirdDurationIconData": Icons.remove,
    "thirdDurationIconColor": Colors.red.shade200,
    "thirdDurationSign": -1,
    "thirdDurationTextColor": Colors.red.shade200,
    "thirdDurationStr": "00:00",
    "thirdStartDateTimeStr": "12-07-2022 16:00",
    "thirdEndDateTimeStr": "12-07-2022 16:00",
    "preferredDurationsItemsStr": '{"good":["12:00","3:30","10:30"]}',
    "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
    "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
    "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
    "calcSlDurCurrSleepDurationStr": '12:36',
    "calcSlDurCurrWakeUpDurationStr": '0:02',
    "calcSlDurCurrTotalDurationStr": '12:38',
    "calcSlDurCurrSleepDurationPercentStr": '99.74 %',
    "calcSlDurCurrWakeUpDurationPercentStr": '0.26 %',
    "calcSlDurCurrTotalDurationPercentStr": '100 %',
    "calcSlDurCurrSleepPrevDayTotalPercentStr": '79.74 %',
    "calcSlDurCurrWakeUpPrevDayTotalPercentStr": '1.26 %',
    "calcSlDurCurrTotalPrevDayTotalPercentStr": '81 %',
    "calcSlDurStatus": Status.sleep,
    "calcSlDurSleepTimeStrHistory": ['10-07-2022 00:58', '05:35', '04:00'],
    "calcSlDurWakeUpTimeStrHistory": ['10-07-2022 05:58', '00:35', '01:00'],
    "dtDiffStartDateTimeStr": "2022-07-13 16:09",
    "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
    "dtDiffDurationStr": "24:00",
    "dtDiffAddTimeStr": "1:00",
    "dtDiffFinalDurationStr": "25:00",
    "dtDurationPercentStr": "70 %",
    "dtDurationTotalPercentStr": "90 %",
    "firstTimeStr": "00:10:00",
    "secondTimeStr": "00:05:00",
    "resultTimeStr": "00:15:00",
    "resultPercentStr": "40 %",
    "resultSecondPercentStr": "90 %",
    "divideFirstBySecondCheckBox": false,
  };

  transferDataViewModel.transferDataMap = transferDataMap;
  transferDataViewModel.updateAndSaveTransferData();

  runApp(MyApp(
    transferDataViewModel: transferDataViewModel,
  ));
}

class MyApp extends StatelessWidget {
  final TransferDataViewModel _transferDataViewModel;

  const MyApp({
    Key? key,
    required TransferDataViewModel transferDataViewModel,
  })  : _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('MyApp.build()');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManuallySelectableTextFieldScreen(
          transferDataViewModel: _transferDataViewModel),
    );
  }
}

class ManuallySelectableTextFieldScreen extends StatefulWidget
    with ScreenMixin {
  final TransferDataViewModel _transferDataViewModel;
  final Map<String, dynamic> _transferDataMap;

  ManuallySelectableTextFieldScreen({
    super.key,
    required TransferDataViewModel transferDataViewModel,
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataViewModel.getTransferDataMap() ?? {};

  @override
  State<ManuallySelectableTextFieldScreen> createState() =>
      _ManuallySelectableTextFieldScreenState(
          transferDataViewModel: _transferDataViewModel,
          transferDataMap: _transferDataMap);

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
    print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
  }
}

class _ManuallySelectableTextFieldScreenState
    extends State<ManuallySelectableTextFieldScreen> with ScreenMixin {
  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;
  late TextEditingController _firstTimeTextFieldController;
  late TextEditingController _durationTextFieldController;
  final _firstTimeTextFieldFocusNode = FocusNode();

  String _firstTimeStr = '';

  _ManuallySelectableTextFieldScreenState({
    required TransferDataViewModel transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String nowStr = ScreenMixin.englishDateTimeFormat.format(DateTime.now());
    _transferDataMap["addDurStartDateTimeStr"] = nowStr;
    _transferDataMap["firstStartDateTimeStr"] = nowStr;
    _transferDataMap["firstEndDateTimeStr"] = nowStr;

    _firstTimeStr = _transferDataMap['firstTimeStr'] ?? '00:00:00';

    _firstTimeTextFieldController = TextEditingController(text: _firstTimeStr);
    _durationTextFieldController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _firstTimeTextFieldController.dispose();
    _durationTextFieldController.dispose();

    _firstTimeTextFieldFocusNode.dispose();

    super.dispose();
  }

  void _updateTransferDataMap() {
    _transferDataMap['firstTimeStr'] = _firstTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();
  }


  void _handleDurationTextFieldChange([
    String? durationStr,
    int? durationSign,
    bool? wasDurationSignButtonPressed,
  ]) {
    String durationStr =
        Utility.formatStringDuration(durationStr: _durationTextFieldController.text);

    // necessary in case the durationStr was set to an
    // int value, like 2 instead of 2:00 !
    _durationTextFieldController.text = durationStr;

    _updateTransferDataMap(); // must be executed before calling
    // the next DurationDateTimeEditor widget
    // setStartDateTimeStr() method in order for the transfer
    // data map to be updated before the last linked third
    // DurationDateTimeEditor widget
    // _updateTransferDataMap() method calls the
    // TransferDataViewModel.updateAndSaveTransferData()
    // method !
  }

  void _handleTimeTextFieldChange([
    String? timeTextFieldStr,
    int? _,
    bool? __,  ]) {
    _firstTimeStr = Utility.formatStringDuration(
      durationStr: timeTextFieldStr!,
      dayHourMinuteFormat: true,
    );
    _firstTimeTextFieldController.text = _firstTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the next DurationDateTimeEditor widget
    // setStartDateTimeStr() method in order for the transfer
    // data map to be updated before the last linked third
    // DurationDateTimeEditor widget
    // _updateTransferDataMap() method calls the
    // TransferDataViewModel.updateAndSaveTransferData()
    // method !
  }

  @override
  Widget build(BuildContext context) {
    // print('_FlutterEditableDateTimeScreenState.build()');
    ManuallySelectableTextField manuallySelectableDurationTextField =
        ManuallySelectableTextField(
      transferDataViewModel: _transferDataViewModel,
      textFieldController: _durationTextFieldController,
      handleTextFieldChangeFunction: _handleDurationTextFieldChange,
    );

    ManuallySelectableTextField manuallySelectableTimeTextField =
        ManuallySelectableTextField(
      transferDataViewModel: _transferDataViewModel,
      textFieldController: _firstTimeTextFieldController,
      handleTextFieldChangeFunction: _handleTimeTextFieldChange,
    );

    return Scaffold(
      backgroundColor: ScreenMixin.APP_LIGHT_BLUE_COLOR,
      appBar: AppBar(
        title: const Text('Manually selectable TextField'),
        centerTitle: true,
        backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
      ),
      body: Container(
        color: ScreenMixin.APP_LIGHT_BLUE_COLOR,
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: ScreenMixin.app_computed_vertical_top_margin),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Time (dd:hh:mm) | %',
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
                        behavior: HitTestBehavior.opaque,
                        child: IgnorePointer(
                          // Prevents displaying copy menu after selecting in
                          // TextField.
                          // Required for onLongPress selection to work
                          child: TextField(
                            key: const Key('firstTimeTextField'),
                            // Required, otherwise, field not focusable due to
                            // IgnorePointer wrapping
                            focusNode: _firstTimeTextFieldFocusNode,
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
                              _handleTimeTextFieldChange(val);
                            },
                          ),
                        ),
                        onTap: () {
                          // Required, otherwise, duration field not focusable
                          FocusScope.of(context).requestFocus(
                            _firstTimeTextFieldFocusNode,
                          );

                          // Positioning the cursor to the end of TextField content.
                          // WARNING: works only if keyboard is displayed or other
                          // duration field is in edit mode !
                          _firstTimeTextFieldController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: _firstTimeTextFieldController.text.length,
                            ),
                          );
                        },
                        onDoubleTap: () async {
                          await handleClipboardDataEditableDuration(
                            context: context,
                            textEditingController:
                                _firstTimeTextFieldController,
                            transferDataMap: _transferDataMap,
                            handleDataChangeFunction:
                                (BuildContext c, String s) {
                              _firstTimeStr = Utility.formatStringDuration(
                                durationStr: s,
                                dayHourMinuteFormat: true,
                              );
                              _firstTimeTextFieldController.text =
                                  _firstTimeStr;
                              _updateTransferDataMap();
                            },
                          );
                        },
                        onLongPress: () {
                          // Requesting focus avoids necessity to first tap on
                          // TextField before long pressing on it to select its
                          // content !
                          FocusScope.of(context).requestFocus(
                            _firstTimeTextFieldFocusNode,
                          );
                          _firstTimeTextFieldController.selection =
                              TextSelection(
                            baseOffset: 0,
                            extentOffset:
                                _firstTimeTextFieldController.text.length,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistance,
                  ),
                  Text(
                    'Duration',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 4, 0, 0), // val
//                                          4 is compliant with current value 5
//                                          of APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        ),
                      ),
                      child: manuallySelectableDurationTextField,
                    ),
                  ),
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistance,
                  ),


                  Text(
                    'Time (dd:hh:mm) | %',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 4, 0, 0), // val
//                                          4 is compliant with current value 5
//                                          of APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        ),
                      ),
                      child: manuallySelectableTimeTextField,
                    ),
                  ),
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistance,
                  ),



                  ElevatedButton(
                    key: const Key('editableDateTimeSelButton'),
                    style: ButtonStyle(
                        backgroundColor: appElevatedButtonBackgroundColor,
                        shape: appElevatedButtonRoundedShape),
                    onPressed: () {
                      Color manuallySelectableTextFieldColor =
                          manuallySelectableDurationTextField.getTextColor();
                      if (manuallySelectableTextFieldColor ==
                          Colors.green.shade200) {
                        manuallySelectableTextFieldColor = Colors.red.shade200;
                      } else {
                        manuallySelectableTextFieldColor =
                            Colors.green.shade200;
                      }
                      manuallySelectableDurationTextField
                          .setTextColor(manuallySelectableTextFieldColor);
                    },
                    child: const Text(
                      'Change color',
                      style: TextStyle(
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManuallySelectableTextField extends StatefulWidget {
  final TransferDataViewModel _transferDataViewModel;
  final Map<String, dynamic> _transferDataMap;

  late final _ManuallySelectableTextFieldState stateInstance;
  late final TextEditingController textFieldController;

  void Function([
    String? textFieldStr,
    int? durationSign,
    bool? wasDurationSignButtonPressed,
  ]) handleTextFieldChangeFunction;

  ManuallySelectableTextField({
    super.key,
    required TransferDataViewModel transferDataViewModel,
    required this.textFieldController,
    required this.handleTextFieldChangeFunction,
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataViewModel.getTransferDataMap() ?? {};

  @override
  State<ManuallySelectableTextField> createState() {
    stateInstance = _ManuallySelectableTextFieldState(
        transferDataViewModel: _transferDataViewModel,
        transferDataMap: _transferDataMap,
        textFieldController: textFieldController,
        handleTextFieldChangeFunction: handleTextFieldChangeFunction);

    return stateInstance;
  }

  Color getTextColor() {
    return stateInstance.getTextColor();
  }

  void setTextColor(Color textColor) {
    stateInstance.setTextColor(textColor);
  }
}

class _ManuallySelectableTextFieldState
    extends State<ManuallySelectableTextField> with ScreenMixin {
  final TransferDataViewModel _transferDataViewModel;
  final Map<String, dynamic> _transferDataMap;
  final _textfieldFocusNode = FocusNode();
  Color _durationTextColor = Colors.green.shade200;

  late final TextEditingController textFieldController;

  final void Function([
    String? textFieldStr,
    int? durationSign,
    bool? wasDurationSignButtonPressed,
  ]) handleTextFieldChangeFunction;

  _ManuallySelectableTextFieldState({
    required TransferDataViewModel transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
    required this.textFieldController,
    required this.handleTextFieldChangeFunction,
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String nowStr = ScreenMixin.englishDateTimeFormat.format(DateTime.now());
    _transferDataMap["addDurStartDateTimeStr"] = nowStr;
    _transferDataMap["firstStartDateTimeStr"] = nowStr;
    _transferDataMap["firstEndDateTimeStr"] = nowStr;

    textFieldController.text = _transferDataMap['firstDurationStr'] ?? '00:00:00';
  }

  @override
  void dispose() {
    _textfieldFocusNode.dispose();

    super.dispose();
  }

  Color getTextColor() {
    return _durationTextColor;
  }

  void setTextColor(Color textColor) {
    _durationTextColor = textColor;

    setState(() {}); // WARNING: setState() method must not be
    //                           called a second time in the
    //                           setTextColor() calling code in
    //                           order to avoid "Field
    //                           'stateInstance'has not been
    //                           initialized" error !
  }

  void _updateTransferDataMap() {
    _transferDataMap['firstDurationStr'] = textFieldController.text;

    _transferDataViewModel.updateAndSaveTransferData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(
        // Prevents displaying copy menu after selecting in
        // TextField.
        // Required for onLongPress selection to work
        child: TextField(
          key: const Key('durationTextField'),
          // Required, otherwise, field not focusable due to
          // IgnorePointer wrapping
          focusNode: _textfieldFocusNode,
          decoration: const InputDecoration.collapsed(hintText: ''),
          style: TextStyle(
              color: _durationTextColor,
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
          keyboardType: TextInputType.datetime,
          controller: textFieldController,
          onSubmitted: (val) {
            // solve the unsolvable problem of onChange()
            // which set cursor at TextField start position !
            handleTextFieldChangeFunction(val);
          },
        ),
      ),
      onTap: () {
        // Required, otherwise, duration field not focusable
        FocusScope.of(context).requestFocus(
          _textfieldFocusNode,
        );

        // Positioning the cursor to the end of TextField content.
        // WARNING: works only if keyboard is displayed or other
        // duration field is in edit mode !
        textFieldController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: textFieldController.text.length,
          ),
        );
      },
      onDoubleTap: () async {
        await handleClipboardDataDurationDateTimeEditor(
            context: context,
            textEditingController: textFieldController,
            transferDataMap: _transferDataViewModel.getTransferDataMap()!,
            handleDataChangeFunction: handleTextFieldChangeFunction);
      },
      onLongPress: () {
        // Requesting focus avoids necessity to first tap on
        // TextField before long pressing on it to select its
        // content !
        FocusScope.of(context).requestFocus(
          _textfieldFocusNode,
        );
        textFieldController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textFieldController.text.length,
        );
      },
    );
  }
}
