import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';

class AddDurationToDateTime extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  final TransferDataViewModel _transferDataViewModel;

  AddDurationToDateTime({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
    required TransferDataViewModel transferDataViewModel,
  })  : _screenNavigTransData = screenNavigTransData,
        _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  _AddDurationToDateTimeState createState() {
    return _AddDurationToDateTimeState(
        transferDataMap: _screenNavigTransData.transferDataMap,
        transferDataViewModel: _transferDataViewModel);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _AddDurationToDateTimeState extends State<AddDurationToDateTime>
    with ScreenMixin {
  _AddDurationToDateTimeState(
      {required Map<String, dynamic> transferDataMap,
      required TransferDataViewModel transferDataViewModel})
      : _transferDataMap = transferDataMap,
        _transferDataViewModel = transferDataViewModel,
        _startDateTimeStr = transferDataMap['addDurStartDateTimeStr'] ??
            DateTime.now().toString(),
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _startDateTimeStr = '';

  late TextEditingController _startDateTimePickerController;

  late DurationDateTimeEditor _firstDurationDateTimeEditorWidget;
  late DurationDateTimeEditor _secondDurationDateTimeEditorWidget;
  late DurationDateTimeEditor _thirdDurationDateTimeEditorWidget;

  // Although defined in ScreenMixin, must be defined here since it is used in the
  // constructor where accessing to mixin data is not possible !
  final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

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

    // calling the callSetState() method of the three custom
    // DurationDateTimeEditor widgets

    _firstDurationDateTimeEditorWidget.callSetState();
    _secondDurationDateTimeEditorWidget.callSetState();
    _thirdDurationDateTimeEditorWidget.callSetState();

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

    String nowEnglishFormatDateTimeStr = _updateWidgets();

    _thirdDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('thirdAddSubtractResultableDuration'),
      widgetName: 'third',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 550.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: null,
      saveTransferDataIfModified: true,
    );

    _secondDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('secondAddSubtractResultableDuration'),
      widgetName: 'second',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 350.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _thirdDurationDateTimeEditorWidget,
    );

    _firstDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('firstAddSubtractResultableDuration'),
      widgetName: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 210.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _secondDurationDateTimeEditorWidget,
    );
  }

  String _updateWidgets() {
    final DateTime dateTimeNow = DateTime.now();

    // String value used to initialize DateTimePicker field
    String nowEnglishFormatDateTimeStr = dateTimeNow.toString();

    String startDateTimeStr = _transferDataMap['addDurStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    if (startDateTimeStr == "") {
      // solving a bug ...
      startDateTimeStr = nowEnglishFormatDateTimeStr;
    }

    _startDateTimePickerController = TextEditingController(
        text: DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: startDateTimeStr)!);

    return nowEnglishFormatDateTimeStr;
  }

  @override
  void dispose() {
    _startDateTimePickerController.dispose();

    if (_transferDataMap['currentScreenStateInstance'] == this) {
      _transferDataMap['currentScreenStateInstance'] = null;
    }

    super.dispose();
  }

  void _updateTransferDataMap() {
    _transferDataMap['addDurStartDateTimeStr'] = _startDateTimeStr;

    setState(() {});
  }

  void _resetScreen() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimePickerEnglishFormatStr = dateTimeNow.toString();

    _startDateTimeStr = nowDateTimePickerEnglishFormatStr;
    _startDateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _startDateTimeStr)!;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.reset();
  }

  void _deleteDurationItem(String selectedDurationItem) {}

  void _handleSelectedDurationItem(String selectedDurationItem) {
    if (selectedDurationItem == 'Add') {
      return;
    }

    if (selectedDurationItem == 'Delete') {
      displayPopupMenu(
        context: context,
        selectableStrItemLst: _buildSelectableDurationItemLst(),
        posRectangleLTRB: const RelativeRect.fromLTRB(
          1.0,
          130.0,
          0.0,
          0.0,
        ),
        handleSelectedItem: _deleteDurationItem,
      );

      return;
    }

    RegExp exp = RegExp(r'(\d+:\d+)');
    Iterable<Match> matches = exp.allMatches(selectedDurationItem);
    List<String> durationStrLst = [];

    for (final Match m in matches) {
      durationStrLst.add(m[0]!);
    }

    // temporarily setting last DurationDateTimeEditor widget
    // saveTransferDataIfModified to false avoids saving transfer
    // data multiple times since setting the duration of a
    // DurationDateTimeEditor causes the start date time of its
    // next DurationDateTimeEditor, and so finaly the last one, to
    // be updated. Saving transfer data multiple times trevents
    // Undoing the application of the selected durations item.
    _thirdDurationDateTimeEditorWidget.saveTransferDataIfModified = false;

    _firstDurationDateTimeEditorWidget.setDuration(durationStrLst[0]);
    _secondDurationDateTimeEditorWidget.setDuration(durationStrLst[1]);

    // restoring the last DurationDateTimeEditor widget
    // saveTransferDataIfModified to true is necessary to enable
    // the last DurationDateTimeEditor duration field to be updated
    // as well as saved, making Undo effective.
    _thirdDurationDateTimeEditorWidget.saveTransferDataIfModified = true;

    _thirdDurationDateTimeEditorWidget.setDuration(durationStrLst[2]);
  }

  void _handleSelectedStartDateTimeStr(String frenchFormatSelectedDateTimeStr) {
    DateTime selectedDateTime =
        frenchDateTimeFormat.parse(frenchFormatSelectedDateTimeStr);
    String englishFormatStartDateTimeStr = selectedDateTime.toString();

    _startDateTimeStr = englishFormatStartDateTimeStr;
    _startDateTimePickerController.text = frenchFormatSelectedDateTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);
  }

  /// Private method called each time when the third End date
  /// time value is changed.
  void _updateThirdDuration(String thirdEndDateTimeEnglishFormatStr) {}

  void handleStartDateTimeChange(String englishFormatStartDateTimeStr) {
    _startDateTimeStr = englishFormatStartDateTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);
  }

  List<String> _buildDurationPopupMenuItemLst() {
    List<String> durationSelectableItemLst = _buildSelectableDurationItemLst();

    // and adding 'Add' and 'Delete' items

    durationSelectableItemLst.add("Add");
    durationSelectableItemLst.add("Delete");

    return durationSelectableItemLst;
  }

  List<String> _buildSelectableDurationItemLst() {
    List<String> durationSelectableItemLst = [];
    const String durationDefinedItemStr =
        '{"short": ["7:00", "3:30", "7:30"], "good": ["12:00", "3:30", "10:30"]}';

    Map<String, dynamic> durationDefinedItemMap =
        jsonDecode(durationDefinedItemStr);

    for (var entry in durationDefinedItemMap.entries) {
      List<dynamic> durationLst = entry.value;

      durationSelectableItemLst.add('${entry.key} ${durationLst.join(', ')}');
    }

    // now sorting the DateTime list

    durationSelectableItemLst.sort();
    return durationSelectableItemLst;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
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
                    EditableDateTime(
                      dateTimeTitle: 'Start date time',
                      dateTimePickerController: _startDateTimePickerController,
                      handleDateTimeModificationFunction:
                          handleStartDateTimeChange,
                      transferDataMap: _transferDataMap,
                      handleSelectedDateTimeStrFunction:
                          _handleSelectedStartDateTimeStr,
                      topSelMenuPosition: 135.0,
                      transferDataViewModel: _transferDataViewModel,
                    ),
                    // First duration addition/subtraction
                    _firstDurationDateTimeEditorWidget,
                    const SizedBox(
                      //  necessary since
                      //                  EditableDateTime must
                      //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                      //                  height ...
                      height: kVerticalFieldDistanceAddSubScreen,
                    ),
                    // Second duration addition/subtraction
                    _secondDurationDateTimeEditorWidget,
                    const SizedBox(
                      //  necessary since
                      //                  EditableDateTime must
                      //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                      //                  height ...
                      height: kVerticalFieldDistanceAddSubScreen,
                    ),
                    // Second duration addition/subtraction
                    _thirdDurationDateTimeEditorWidget,
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: Column(
                  children: const [],
                ),
              ),
              SizedBox(
                height: screenHeight *
                    ScreenMixin.APP_VERTICAL_TOP_RESET_BUTTON_MARGIN_PROPORTION,
              ),
              ResetButton(
                onPress: _resetScreen,
              ),
              Positioned(
                right: 2,
                top: -3,
                child: Column(
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        displayPopupMenu(
                          context: context,
                          selectableStrItemLst: _buildDurationPopupMenuItemLst(),
                          posRectangleLTRB: const RelativeRect.fromLTRB(
                            1.0,
                            125.0,
                            0.0,
                            0.0,
                          ),
                          handleSelectedItem: _handleSelectedDurationItem,
                        );
                      },
                      icon: Icon(
                        Icons.favorite,
                        // color: ScreenMixin.APP_MATERIAL_APP_LIGHTER_YELLOW_COLOR,
                        color: ScreenMixin.APP_MATERIAL_APP_LIGHTER_YELLOW_COLOR,
                        size: 27,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }
}
