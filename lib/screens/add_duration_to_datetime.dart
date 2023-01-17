import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import '../model/menu_item_data.dart';

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
        super();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _startEnglishFormatDateTimeStr = '';

  late TextEditingController _startDateTimePickerController;
  final TextEditingController _addDurationPreferenceNameController =
      TextEditingController(text: '');
  final TextEditingController _addDurationPreferenceValueController =
      TextEditingController(text: '');

  late DurationDateTimeEditor _firstDurationDateTimeEditorWidget;
  late DurationDateTimeEditor _secondDurationDateTimeEditorWidget;
  late DurationDateTimeEditor _thirdDurationDateTimeEditorWidget;

  // Although defined in ScreenMixin, must be defined here since it is used in the
  // constructor where accessing to mixin data is not possible !
  final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  bool _isPreferredDurationBold = false;

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
      widgetPrefix: 'third',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 550.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: null,
      saveTransferDataIfModified: true,
      position: ToastGravity.BOTTOM,
    );

    _secondDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('secondAddSubtractResultableDuration'),
      widgetPrefix: 'second',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 350.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _thirdDurationDateTimeEditorWidget,
    );

    _firstDurationDateTimeEditorWidget = DurationDateTimeEditor(
      key: const Key('firstAddSubtractResultableDuration'),
      widgetPrefix: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 210.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _secondDurationDateTimeEditorWidget,
      position: ToastGravity.TOP,
    );
  }

  String _updateWidgets() {
    final DateTime dateTimeNow = DateTime.now();

    // String value used to initialize DateTimePicker field
    String nowEnglishFormatDateTimeStr = dateTimeNow.toString();

    String startEnglishFormatDateTimeStr =
        _transferDataMap['addDurStartDateTimeStr'] ?? '';

    if (startEnglishFormatDateTimeStr == "") {
      _startEnglishFormatDateTimeStr = nowEnglishFormatDateTimeStr;
      _startDateTimePickerController = TextEditingController(
          text: DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
              englishFormatDateTimeStr: nowEnglishFormatDateTimeStr)!);
    } else {
      _startEnglishFormatDateTimeStr = startEnglishFormatDateTimeStr;
      _startDateTimePickerController = TextEditingController(
          text: DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
              englishFormatDateTimeStr: startEnglishFormatDateTimeStr));
    }

    return nowEnglishFormatDateTimeStr;
  }

  @override
  void dispose() {
    _startDateTimePickerController.dispose();
    _addDurationPreferenceNameController.dispose();
    _addDurationPreferenceValueController.dispose();

    if (_transferDataMap['currentScreenStateInstance'] == this) {
      _transferDataMap['currentScreenStateInstance'] = null;
    }

    super.dispose();
  }

  void _updateTransferDataMap() {
    _transferDataMap['addDurStartDateTimeStr'] = _startEnglishFormatDateTimeStr;

    setState(() {});
  }

  /// Public method called when clicking on Main screen'Reset' button.
  void resetScreen() {
    // When resetting the 1dt screen, its Start date time is set
    // to the last date time value added to the 3rd screen.
    String sleepDurationScreenLastDateTimeFrenchFormatStr =
        _transferDataMap['calcSlDurPreviousDateTimeStr'];

    if (sleepDurationScreenLastDateTimeFrenchFormatStr == '') {
      // String value used to initialize DateTimePicker field
      sleepDurationScreenLastDateTimeFrenchFormatStr =
          ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
    }
    _startEnglishFormatDateTimeStr =
        DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
            frenchFormatDateTimeStr:
                sleepDurationScreenLastDateTimeFrenchFormatStr)!;
    _startDateTimePickerController.text =
        sleepDurationScreenLastDateTimeFrenchFormatStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.reset(
        resetDateTimeEnglishFormatStr:
            DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                    frenchFormatDateTimeStr:
                        sleepDurationScreenLastDateTimeFrenchFormatStr) ??
                '');
  }

  void _deletePreferredDurationItem(String selectedPreferredDurationItem,
      [BuildContext? context]) {
    if (context == null) {
      return;
    }

    Map<String, dynamic> durationDefinedItemMap =
        _getPreferredDurationsItemMap();
    String selectedDurationItemKey =
        _getPreferredDurationItemName(selectedPreferredDurationItem);

    String selectedDurationItemStr =
        _transferDataMap['preferredDurationsItemsStr'];
    Map<String, dynamic> selectedDurationItemMap =
        jsonDecode(selectedDurationItemStr);

    // before deleting preferred duration item, set the two
    // add preferred duration item controllers text to the
    // deleted elements

    _addDurationPreferenceNameController.text = selectedDurationItemKey;

    List<dynamic> selectedDurationItemValueLst =
        selectedDurationItemMap[selectedDurationItemKey];
    String selectedDurationItemValueStr =
        selectedDurationItemValueLst.join(', ');

    _addDurationPreferenceValueController.text = selectedDurationItemValueStr;

    // now, deleting the preferred duration item

    durationDefinedItemMap.remove(selectedDurationItemKey);

    _transferDataMap['preferredDurationsItemsStr'] =
        jsonEncode(durationDefinedItemMap);
    _transferDataViewModel.updateAndSaveTransferData();
  }

  String _getPreferredDurationItemName(String string) {
    // the RegExp below is the uniue possibility of extracting
    // 'Item name %' from 'Item name % 1:00, 2:00, 3:00' !
    RegExp regExp = RegExp(r'([^:]+ )([\d:, ]+)');
    RegExpMatch? firstMatch = regExp.firstMatch(string);

    String name = '';

    if (firstMatch != null) {
      name = firstMatch.group(1)!.trimRight();
    }

    return name;
  }

  /// Method called when clicking on a menu item.
  Future<void> _handlePreferredDurationMenuItemSelection(
      String selectedDurationItem,
      [BuildContext? context]) async {
    if (context == null) {
      return;
    }

    if (selectedDurationItem == 'Add') {
      await _openAddNewPreferredDurationDialog(context: context);
      String? preferredDurationsItemStr = _buildPreferredDurationsItemStr();

      if (preferredDurationsItemStr != null) {
        _transferDataMap['preferredDurationsItemsStr'] =
            preferredDurationsItemStr;
        _transferDataViewModel.updateAndSaveTransferData();
      }

      return;
    }

    if (selectedDurationItem == 'Delete') {
      displayPopupMenu(
        context: context,
        selMenuDateTimeItemData: _buildPreferredDurationsItemLst(),
        posRectangleLTRB: const RelativeRect.fromLTRB(
          1.0,
          125.0,
          0.0,
          0.0,
        ),
        handleSelectedItemFunction: _deletePreferredDurationItem,
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

    _startEnglishFormatDateTimeStr = englishFormatStartDateTimeStr;
    _startDateTimePickerController.text = frenchFormatSelectedDateTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);
  }

  void handleStartDateTimeChange(String englishFormatStartDateTimeStr) {
    _startEnglishFormatDateTimeStr = englishFormatStartDateTimeStr;

    _updateTransferDataMap(); // must be executed before calling
    // the AddSubtractResultableDuration widget reset method in order
    // for the transfer data map to be updated before the last linked
    // third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    _firstDurationDateTimeEditorWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);
  }

  MenuItemData _buildPreferredDurationsPopupMenuItemLst() {
    MenuItemData selMenuDateTimeItemData = _buildPreferredDurationsItemLst();
    List<String> durationSelectableItemLst =
        selMenuDateTimeItemData.itemDataStrLst;

    // and adding 'Add' and 'Delete' items

    durationSelectableItemLst.add("Add");
    durationSelectableItemLst.add("Delete");

    return MenuItemData(
      itemDataStrLst: durationSelectableItemLst,
    );
  }

  /// Returns null if preferredDurationsItemName is '', example
  /// {"ok":["12:00","4:00","10:00"],"new":["15:00","4:00","11:00"]} otherwise.
  String? _buildPreferredDurationsItemStr() {
    String preferredDurationsItemName =
        _addDurationPreferenceNameController.text.trim();
    String preferredDurationsItemValue =
        _addDurationPreferenceValueController.text;

    if (preferredDurationsItemName == '' || preferredDurationsItemValue == '') {
      // the case if Cancel button was pressed or if Clear
      // button was pressed and no data was entered
      return null;
    }

    Map<String, dynamic> currentPreferredDurationsItemMap =
        _getPreferredDurationsItemMap();

    List<String> parsedTimeStrLst =
        DateTimeParser.parseAllIntOrHHMMTimeStr(preferredDurationsItemValue);

    // List<String> parsedTimeStrLst =
    //     DateTimeParser.parseAllHHMMTimeStr(preferredDurationsItemValue);

    currentPreferredDurationsItemMap[preferredDurationsItemName] =
        parsedTimeStrLst;

    String preferredDurationsItemFormattedValueStr =
        parsedTimeStrLst.join(', ');

    _addDurationPreferenceValueController.text =
        preferredDurationsItemFormattedValueStr;

    return jsonEncode(currentPreferredDurationsItemMap);
  }

  Map<String, dynamic> _getPreferredDurationsItemMap() {
    // _transferDataMap['preferredDurationsItemsStr'] returns
    // null in case the Circadian app is started after deleting
    // the circadian.json file !
    String currentPreferredDurationsItemStr =
        _transferDataMap['preferredDurationsItemsStr'] ?? '';

    Map<String, dynamic> currentPreferredDurationsItemMap = {};

    if (currentPreferredDurationsItemStr != '') {
      currentPreferredDurationsItemMap =
          jsonDecode(currentPreferredDurationsItemStr);
    }

    return currentPreferredDurationsItemMap;
  }

  MenuItemData _buildPreferredDurationsItemLst() {
    List<String> durationSelectableItemLst = [];
    Map<String, dynamic> durationDefinedItemMap =
        _getPreferredDurationsItemMap();

    for (var entry in durationDefinedItemMap.entries) {
      List<dynamic> durationLst = entry.value;

      durationSelectableItemLst.add('${entry.key} ${durationLst.join(', ')}');
    }

    // now sorting the DateTime list

    durationSelectableItemLst.sort();

    return MenuItemData(
      itemDataStrLst: durationSelectableItemLst,
    );
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
                    key: const Key('addDurToDateTimeStartDateTime'),
                    dateTimeTitle: 'Start date time',
                    dateTimePickerController: _startDateTimePickerController,
                    handleDateTimeModificationFunction:
                        handleStartDateTimeChange,
                    transferDataMap: _transferDataMap,
                    handleSelectedDateTimeStrFunction:
                        _handleSelectedStartDateTimeStr,
                    topSelMenuPosition: 135.0,
                    transferDataViewModel: _transferDataViewModel,
                    position: ToastGravity.TOP,
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
                  // Third duration addition/subtraction
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
                        selMenuDateTimeItemData:
                            _buildPreferredDurationsPopupMenuItemLst(),
                        posRectangleLTRB: const RelativeRect.fromLTRB(
                          1.0,
                          125.0,
                          0.0,
                          0.0,
                        ),
                        handleSelectedItemFunction:
                            _handlePreferredDurationMenuItemSelection,
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      // color: ScreenMixin.APP_MATERIAL_APP_LIGHTER_YELLOW_COLOR,
                      color: ScreenMixin.APP_MATERIAL_APP_LIGHTER_YELLOW_COLOR,
                      size: 27,
                    ),
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
      ),
    );
  }

  Future<String?> _openAddNewPreferredDurationDialog(
      {required BuildContext context}) {
    void submit() {
      Navigator.of(context).pop();
    }

    return showDialog<String>(
        context: context,
        // so, clicking outside the dialog screen does not close it.
        // Instead, Cancel button was added ...
        barrierDismissible: false,
        builder: (context) {
          // since AlertDialog is stateless, checkbox does not work.
          // Using StatefulBuilder solves the problem.
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add new preferred durations menu item'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //position
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Text('Name'),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Text('Value'),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                          decoration: const InputDecoration(hintText: ''),
                          controller: _addDurationPreferenceValueController,
                          onSubmitted: (_) => submit(),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Text('Bold'),
                      ),
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.white70,
                        ),
                        child: SizedBox(
                          width: ScreenMixin.CHECKBOX_WIDTH_HEIGHT,
                          height: ScreenMixin.CHECKBOX_WIDTH_HEIGHT,
                          child: Checkbox(
                            key: const Key('preferredDurationBoldCheckbox'),
                            value: _isPreferredDurationBold,
                            onChanged: (value) {
                              setState(
                                () {
                                  _isPreferredDurationBold = value!;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addDurationPreferenceNameController.text = '';
                    _addDurationPreferenceValueController.text = '';
                    _isPreferredDurationBold = false;
                    submit();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _addDurationPreferenceNameController.text = '';
                    _addDurationPreferenceValueController.text = '';
                    _isPreferredDurationBold = false;
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: submit,
                  child: const Text('Add menu item'),
                ),
              ],
            );
          });
        });
  }
}
