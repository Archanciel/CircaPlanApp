// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/widgets/flutter_editable_date_time.dart';
import '../buslog/transfer_data_view_model.dart';
import 'duration_date_time_editor.dart';

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
          '$kDownloadAppDir${Platform.pathSeparator}$kDefaultJsonFileName');
  Map<String, dynamic> transferDataMap = {
    "firstDurationIconData": Icons.add,
    "firstDurationIconColor": Colors.green.shade200,
    "firstDurationSign": 1,
    "firstDurationTextColor": Colors.green.shade200,
    "firstDurationStr": "00:00",
  };

  @override
  State<FlutterEditableDateTimeScreen> createState() =>
      _FlutterEditableDateTimeScreenState();

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
    print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
  }
}

class _FlutterEditableDateTimeScreenState
    extends State<FlutterEditableDateTimeScreen> {
  late DurationDateTimeEditor _firstDurationDateTimeEditorWidget;
  late TextEditingController dateTimePickerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dateTimePickerController = TextEditingController(
        text: widget.frenchDateTimeFormat.format(DateTime.now()));

    _firstDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('firstAddSubtractResultableDuration'),
      widgetName: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 210.0,
      nowDateTimeEnglishFormatStr: DateTime.now().toString(),
      transferDataViewModel: widget.transferDataViewModel,
      transferDataMap: widget.transferDataMap,
      nextAddSubtractResultableDuration: null,
    );

    String nowStr = widget.englishDateTimeFormat.format(DateTime.now());
    widget.transferDataMap["addDurStartDateTimeStr"] = nowStr;
    widget.transferDataMap["firstStartDateTimeStr"] = nowStr;
    widget.transferDataMap["firstEndDateTimeStr"] = nowStr;
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
                    dateTimePickerController: dateTimePickerController,
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
