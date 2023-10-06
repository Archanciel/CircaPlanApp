import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import '../buslog/transfer_data_view_model.dart';
import '../utils/utility.dart';
import 'manually_selectable_text_field.dart';

void main() {
  final TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kCircadianAppDir${Platform.pathSeparator}manuallySelectableTextField.json');

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

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {}

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {}
}

class _ManuallySelectableTextFieldScreenState
    extends State<ManuallySelectableTextFieldScreen> with ScreenMixin {
  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;
  late TextEditingController _firstTimeTextFieldController;
  late TextEditingController _durationTextFieldController;
  late ManuallySelectableTextField manuallySelectableDurationTextField;
  late ManuallySelectableTextField manuallySelectableTimeTextField;

  final _firstTimeTextFieldFocusNode = FocusNode();

  String _firstTimeStr = '';

  _ManuallySelectableTextFieldScreenState({
    required TransferDataViewModel transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap;

  @override
  void initState() {
    super.initState();

    String nowStr = englishDateTimeFormat.format(DateTime.now());
    _transferDataMap["addDurStartDateTimeStr"] = nowStr;
    _transferDataMap["firstStartDateTimeStr"] = nowStr;
    _transferDataMap["firstEndDateTimeStr"] = nowStr;

    _firstTimeStr = _transferDataMap['firstTimeStr'] ?? '00:00:00';

    _firstTimeTextFieldController = TextEditingController(text: _firstTimeStr);
    _durationTextFieldController = TextEditingController(text: '');

    manuallySelectableDurationTextField = ManuallySelectableTextField(
      transferDataViewModel: _transferDataViewModel,
      textFieldController: _durationTextFieldController,
      handleTextFieldChangeFunction: _handleDurationTextFieldChange,
    );

    manuallySelectableTimeTextField = ManuallySelectableTextField(
      transferDataViewModel: _transferDataViewModel,
      textFieldController: _firstTimeTextFieldController,
      handleTextFieldChangeFunction: _handleTimeTextFieldChange,
    );
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
    bool? mustEndDateTimeBeRounded,
  ]) {
    String durationStr = Utility.formatStringDuration(
        durationStr: _durationTextFieldController.text);

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
    bool? __,
    bool? ___,
  ]) {
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
