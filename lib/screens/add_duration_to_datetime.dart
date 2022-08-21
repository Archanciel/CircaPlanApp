import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/add_subtract_resultable_duration.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
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

  late TextEditingController _startDateTimePickerController;

  late AddSubtractResultableDuration _firstAddSubtractResultableDurationWidget;
  late AddSubtractResultableDuration _secondAddSubtractResultableDurationWidget;
  late AddSubtractResultableDuration _thirdAddSubtractResultableDurationWidget;

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
    // AddSubtractResultableDuration widgets

    _firstAddSubtractResultableDurationWidget.callSetState();
    _secondAddSubtractResultableDurationWidget.callSetState();
    _thirdAddSubtractResultableDurationWidget.callSetState();

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

    _thirdAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
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

    _secondAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      key: const Key('secondAddSubtractResultableDuration'),
      widgetName: 'second',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 350.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration:
          _thirdAddSubtractResultableDurationWidget,
    );

    _firstAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      key: const Key('firstAddSubtractResultableDuration'),
      widgetName: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 210.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration:
          _secondAddSubtractResultableDurationWidget,
    );
  }

  String _updateWidgets() {
    final DateTime dateTimeNow = DateTime.now();

    // String value used to initialize DateTimePicker field
    String nowEnglishFormatDateTimeStr = dateTimeNow.toString();

    String startDateTimeStr = _transferDataMap['addDurStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    _startDateTimePickerController =
        TextEditingController(text: startDateTimeStr);

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

//    _transferDataViewModel.updateAndSaveTransferData(); saving the
//                           transfer data is performed by the third
//                            AddSubtractResultableDuration widget !
  }

  void _resetScreen() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimePickerEnglishFormatStr = dateTimeNow.toString();

    _startDateTimeStr = nowDateTimePickerEnglishFormatStr;
    _startDateTimePickerController.text = _startDateTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstAddSubtractResultableDurationWidget.reset();
  }

  void _handleSelectedStartDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    String englishFormatStartDateTimeStr = selectedDateTime.toString();

    _startDateTimeStr = englishFormatStartDateTimeStr;
    _startDateTimePickerController.text = _startDateTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstAddSubtractResultableDurationWidget.setStartDateTimeStr(
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

    _firstAddSubtractResultableDurationWidget.setStartDateTimeStr(
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
                  _firstAddSubtractResultableDurationWidget,
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistanceAddSubScreen,
                  ),
                  // Second duration addition/subtraction
                  _secondAddSubtractResultableDurationWidget,
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistanceAddSubScreen,
                  ),
                  // Second duration addition/subtraction
                  _thirdAddSubtractResultableDurationWidget,
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
