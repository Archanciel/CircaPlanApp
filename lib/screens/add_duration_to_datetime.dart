import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';
import 'package:circa_plan/widgets/flutter_editable_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';

class AddDurationToDateTime extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  final TransferDataViewModel _transferDataViewModel;

  const AddDurationToDateTime({
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

  late DurationDateTimeEditor _firstDurationDateTimeEditorWidget;
  late DurationDateTimeEditor _secondDurationDateTimeEditorWidget;
  late DurationDateTimeEditor _thirdDurationDateTimeEditorWidget;

  late EditableDateTime _editableStartDateTime;

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

    // EditableDateTime must be instanciated here and not in
    // _DurationDateTimeEditorState.build() method, otherwise
    // EditableDateTime.stateInstance will not be initialized,
    // which will throw an Exception when clicking on Now or
    // Sel button.
    _editableStartDateTime = EditableDateTime(
      dateTimeTitle: 'Start date time',
      topSelMenuPosition: 135.0,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      handleDateTimeModificationFunction: handleStartDateTimeChange,
      handleSelectedDateTimeStrFunction: _handleSelectedStartDateTimeStr,
    );

    // The reference to the stateful widget State instance stored in
    // the transfer data map is used in the
    // _MainAppState.handleSelectedLoadFileName() method executed after
    // the file to load has been selected in the AppBar load ... sub menu
    // in order to call the current instance callSetState() method.
    _transferDataMap['currentScreenStateInstance'] = this;

    // String nowEnglishFormatDateTimeStr = _updateWidgets();
    final DateTime dateTimeNow = DateTime.now();
    final String nowEnglishFormatDateTimeStr = dateTimeNow.toString();

    final String thirdStartDateTimeStr = _transferDataMap['thirdStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    _thirdDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('thirdAddSubtractResultableDuration'),
      widgetName: 'third',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 550.0,
      nowDateTimeEnglishFormatStr: thirdStartDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: null,
      saveTransferDataIfModified: true,
    );

    final String secondStartDateTimeStr = _transferDataMap['secondStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    _secondDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('secondAddSubtractResultableDuration'),
      widgetName: 'second',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 350.0,
      nowDateTimeEnglishFormatStr: secondStartDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _thirdDurationDateTimeEditorWidget,
    );

    final String firstStartDateTimeStr = _transferDataMap['firstStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    _firstDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('firstAddSubtractResultableDuration'),
      widgetName: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 210.0,
      nowDateTimeEnglishFormatStr: firstStartDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _secondDurationDateTimeEditorWidget,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Adds a call back function called after the _MainAppState
      // build() method has been executed. This solves the problem
      // of the first screen not displaying the values contained in
      // the circadian.json file.
      //
      // This anonymous function is called only once, when the app
      // is launched (or restarted).
      _updateWidgets();
    });
  }

  void _updateWidgets() {
    final DateTime dateTimeNow = DateTime.now();
    final String nowEnglishFormatDateTimeStr = dateTimeNow.toString();
    final String startDateTimeStr = _transferDataMap['addDurStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    _editableStartDateTime.setDateTime(
        englishFormatDateTimeStr: _transferDataMap['addDurStartDateTimeStr'] ??
            startDateTimeStr);
  }

  @override
  void dispose() {
    if (_transferDataMap['currentScreenStateInstance'] == this) {
      _transferDataMap['currentScreenStateInstance'] = null;
    }

    super.dispose();
  }

  void _updateTransferDataMap() {
    _transferDataMap['addDurStartDateTimeStr'] = _startDateTimeStr;

    setState(() {});

//    _transferDataViewModel.updateAndSaveTransferData(); saving the
//                           transfer data is performed by the third
//                            AddSubtractResultableDuration widget !
  }

  void _resetScreen() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimePickerEnglishFormatStr = dateTimeNow.toString();

    _startDateTimeStr = nowDateTimePickerEnglishFormatStr;
    _editableStartDateTime.setDateTime(
        englishFormatDateTimeStr: _startDateTimeStr);

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.reset();
  }

  void _handleSelectedStartDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    String englishFormatStartDateTimeStr = selectedDateTime.toString();

    _startDateTimeStr = englishFormatStartDateTimeStr;
    _editableStartDateTime.setDateTime(
        englishFormatDateTimeStr: _startDateTimeStr);

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
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
                  _editableStartDateTime,

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
                children: [],
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
}
