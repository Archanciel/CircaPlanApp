// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/widgets/flutter_editable_date_time_stateful.dart';
import '../buslog/transfer_data_view_model.dart';
import 'duration_date_time_editor.dart';

/// This code uses the stateful version of flutter EditableDateTime widget.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('MyApp.build()');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterEditableDateTimeScreen(),
    );
  }
}

class FlutterEditableDateTimeScreen extends StatefulWidget with ScreenMixin {
  FlutterEditableDateTimeScreen({Key? key}) : super(key: key);

  final TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kCircadianAppDir${Platform.pathSeparator}$kDefaultJsonFileName');
  final Map<String, dynamic> transferDataMap = {
    "firstDurationIconData": Icons.add,
    "firstDurationIconColor": Colors.green.shade200,
    "firstDurationSign": 1,
    "firstDurationTextColor": Colors.green.shade200,
    "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
    "firstDurationStr": "00:50",
    "firstStartDateTimeStr": "2022-07-12 16:00",
    "firstEndDateTimeStr": "2022-07-12 16:50",
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
  };

  @override
  State<FlutterEditableDateTimeScreen> createState() =>
      _FlutterEditableDateTimeScreenState();

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {}

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {}
}

class _FlutterEditableDateTimeScreenState
    extends State<FlutterEditableDateTimeScreen> {
  late DurationDateTimeEditor _firstDurationDateTimeEditorWidget;

  @override
  void initState() {
    super.initState();

    _firstDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('firstAddSubtractResultableDuration'),
      widgetPrefix: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 210.0,
      nowDateTimeEnglishFormatStr: DateTime.now().toString(),
      transferDataViewModel: widget.transferDataViewModel,
      transferDataMap: widget.transferDataMap,
      nextAddSubtractResultableDuration: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('_FlutterEditableDateTimeScreenState.build()');
    return Scaffold(
      backgroundColor: ScreenMixin.APP_LIGHT_BLUE_COLOR,
      appBar: AppBar(
        title: const Text('Flutter Date Timer Picker'),
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
                  EditableDateTime(
                    dateTimeTitle: 'Start date time',
                    topSelMenuPosition: 120,
                    transferDataViewModel: widget.transferDataViewModel,
                    transferDataMap: widget.transferDataMap,
                    handleDateTimeModificationFunction:
                        widget.handleEndDateTimeChange,
                    handleSelectedDateTimeStrFunction:
                        widget.handleEndDateTimeSelected,
                  ),
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistanceAddSubScreen,
                  ),
                  _firstDurationDateTimeEditorWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
