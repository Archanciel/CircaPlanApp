// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import '../buslog/transfer_data_view_model.dart';
import '../utils/utility.dart';

void main() {
  final TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kDownloadAppDir${Platform.pathSeparator}$kDefaultJsonFileName');
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
    "calcSlDurSleepTimeStrHistory": ['10_07_2022 00:58', '05:35', '04:00'],
    "calcSlDurWakeUpTimeStrHistory": ['10_07_2022 05:58', '00:35', '01:00'],
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
  final String lsonFileName = 'manual_selectable_text_field_main.json';
  final TransferDataViewModel transferDataViewModel;
  final Map<String, dynamic> transferDataMap;

  ManuallySelectableTextFieldScreen({
    Key? key,
    required TransferDataViewModel transferDataViewModel,
  })  : transferDataViewModel = transferDataViewModel,
        transferDataMap = transferDataViewModel.getTransferDataMap()!,
        super(key: key);

  @override
  State<ManuallySelectableTextFieldScreen> createState() =>
      _ManuallySelectableTextFieldScreenState();

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
    print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
  }
}

class _ManuallySelectableTextFieldScreenState
    extends State<ManuallySelectableTextFieldScreen> {
  late TextEditingController _firstTimeTextFieldController;
  late TextEditingController _durationTextFieldController;
  final _firstTimeTextFieldFocusNode = FocusNode();
  final _durationTextfieldFocusNode = FocusNode();
  Color _durationTextColor = Colors.green.shade200;

  String _firstTimeStr = '';
  String _durationTextFieldStr = '';
  String _durationStr = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String nowStr = ScreenMixin.englishDateTimeFormat.format(DateTime.now());
    widget.transferDataMap["addDurStartDateTimeStr"] = nowStr;
    widget.transferDataMap["firstStartDateTimeStr"] = nowStr;
    widget.transferDataMap["firstEndDateTimeStr"] = nowStr;

    _firstTimeStr = widget.transferDataMap['firstTimeStr'] ?? '00:00:00';
    _durationTextFieldStr =
        widget.transferDataMap['firstDurationStr'] ?? '00:00:00';

    _firstTimeTextFieldController = TextEditingController(text: _firstTimeStr);
    _durationTextFieldController =
        TextEditingController(text: _durationTextFieldStr);
  }

  @override
  void dispose() {
    _firstTimeTextFieldController.dispose();
    _durationTextFieldController.dispose();

    _firstTimeTextFieldFocusNode.dispose();
    _durationTextfieldFocusNode.dispose();

    super.dispose();
  }

  void _updateTransferDataMap() {
    widget.transferDataMap['firstTimeStr'] = _firstTimeStr;
    widget.transferDataMap['firstDurationStr'] = _durationStr;

    widget.transferDataViewModel.updateAndSaveTransferData();
  }


  void handleDurationChange({
    String? durationStr,
    int? durationSign,
    bool wasDurationSignButtonPressed = false,
  }) {
    _durationStr = Utility.formatStringDuration(
        durationStr: _durationTextFieldController.text);

    // necessary in case the _durationStr was set to an
    // int value, like 2 instead of 2:00 !
    _durationTextFieldController.text = _durationStr;

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
                    style: widget.labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0), // val 4 is
//                                            compliant with current value 6 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: widget.selectionColor,
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
                            style: widget.valueTextStyle,
                            keyboardType: TextInputType.datetime,
                            controller: _firstTimeTextFieldController,
                            onSubmitted: (val) {
                              // called when manually updating the TextField
                              // content. onChanged must be defined in order for
                              // pasting a value to the TextField to really
                              // modify the TextField value and store it
                              // in the screen navigation transfer
                              // data map.
                              _firstTimeStr = Utility.formatStringDuration(
                                durationStr: val,
                                dayHourMinuteFormat: true,
                              );
                              _firstTimeTextFieldController.text =
                                  _firstTimeStr;
                              setState(() {});
                              _updateTransferDataMap();
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
                          await widget.handleClipboardDataEditableDuration(
                            context: context,
                            textEditingController:
                                _firstTimeTextFieldController,
                            transferDataMap: widget.transferDataMap,
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
                    style: widget.labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 4, 0, 0), // val
//                                          4 is compliant with current value 5
//                                          of APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: widget.selectionColor,
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
                            key: const Key('durationTextField'),
                            // Required, otherwise, field not focusable due to
                            // IgnorePointer wrapping
                            focusNode: _durationTextfieldFocusNode,
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            style: TextStyle(
                                color: _durationTextColor,
                                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                            keyboardType: TextInputType.datetime,
                            controller: _durationTextFieldController,
                            onSubmitted: (val) {
                              // solve the unsolvable problem of onChange()
                              // which set cursor at TextField start position !
                              handleDurationChange(durationStr: val);
                            },
                          ),
                        ),
                        onTap: () {
                          // Required, otherwise, duration field not focusable
                          FocusScope.of(context).requestFocus(
                            _durationTextfieldFocusNode,
                          );

                          // Positioning the cursor to the end of TextField content.
                          // WARNING: works only if keyboard is displayed or other
                          // duration field is in edit mode !
                          _durationTextFieldController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: _durationTextFieldController.text.length,
                            ),
                          );
                        },
                        onDoubleTap: () async {
                          await widget
                              .handleClipboardDataDurationDateTimeEditor(
                                  context: context,
                                  textEditingController:
                                      _durationTextFieldController,
                                  transferDataMap: widget.transferDataViewModel.getTransferDataMap()!,
                                  handleDataChangeFunction:
                                      handleDurationChange);
                        },
                        onLongPress: () {
                          // Requesting focus avoids necessity to first tap on
                          // TextField before long pressing on it to select its
                          // content !
                          FocusScope.of(context).requestFocus(
                            _durationTextfieldFocusNode,
                          );
                          _durationTextFieldController.selection =
                              TextSelection(
                            baseOffset: 0,
                            extentOffset:
                                _durationTextFieldController.text.length,
                          );
                        },
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
