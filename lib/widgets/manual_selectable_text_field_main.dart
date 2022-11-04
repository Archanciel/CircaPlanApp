// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import '../buslog/transfer_data_view_model.dart';
import '../utils/utility.dart';

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
      home: ManualSelectableTextFieldScreen(),
    );
  }
}

class ManualSelectableTextFieldScreen extends StatefulWidget with ScreenMixin {
  ManualSelectableTextFieldScreen({Key? key}) : super(key: key);
  String lsonFileName = 'manual_selectable_text_field_main.json';
  final TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kDownloadAppDir${Platform.pathSeparator}$kDefaultJsonFileName');
  Map<String, dynamic> transferDataMap = {
    "firstTimeStr": "00:00",
  };

  String firstTimeStr = '';

  @override
  State<ManualSelectableTextFieldScreen> createState() =>
      _ManualSelectableTextFieldScreenState();

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
    print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
  }

  void updateTransferDataMap() {
    transferDataMap['firstTimeStr'] = firstTimeStr;

    transferDataViewModel.updateAndSaveTransferData();
  }
}

class _ManualSelectableTextFieldScreenState
    extends State<ManualSelectableTextFieldScreen> {
  late TextEditingController _firstTimeTextFieldController;
  final _firstTimeTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String nowStr = ScreenMixin.englishDateTimeFormat.format(DateTime.now());
    widget.transferDataMap["addDurStartDateTimeStr"] = nowStr;
    widget.transferDataMap["firstStartDateTimeStr"] = nowStr;
    widget.transferDataMap["firstEndDateTimeStr"] = nowStr;

    widget.firstTimeStr = widget.transferDataMap['firstTimeStr'] ?? '00:00:00';

    _firstTimeTextFieldController =
        TextEditingController(text: widget.firstTimeStr);
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
                  Text(
                    'Time (dd:hh:mm)',
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
                              widget.firstTimeStr =
                                  Utility.formatStringDuration(
                                durationStr: val,
                                dayHourMinuteFormat: true,
                              );
                              _firstTimeTextFieldController.text =
                                  widget.firstTimeStr;
                              setState(() {});
                              widget.updateTransferDataMap();
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
                              widget.firstTimeStr =
                                  Utility.formatStringDuration(
                                durationStr: s,
                                dayHourMinuteFormat: true,
                              );
                              _firstTimeTextFieldController.text =
                                  widget.firstTimeStr;
                              widget.updateTransferDataMap();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
