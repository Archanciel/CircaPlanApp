import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget. Additionally,
class AddSubtractResultableDuration extends StatefulWidget with ScreenMixin {
  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  /// TextEditingController passed to this DurationResultDateTime
  /// widget.
  final TextEditingController durationTextFieldController =
      TextEditingController();

  /// Function passed to this DurationResultDateTime widget.
  //final Function _durationChangeFunction;

  late IconData _durationIcon;
  late Color _durationIconColor;
  late Color _durationTextColor;
  String durationStr;
  int _durationSign;

  final String _dateTimeTitle;
  final TextEditingController _dateTimePickerController =
      TextEditingController();
  final TransferDataViewModel _transferDataViewModel;

  // used to fill the display selection popup menu
  final Map<String, dynamic> _transferDataMap;

  final double _topSelMenuPosition;

  /// Constructor parms:
  ///
  /// resultDateTimeController      TextEditingController passed to
  ///                               the included ResultDateTime
  ///                               widget constructor.
  /// durationTextFieldController   TextEditingController linked
  ///                               to the duration TextField.
  /// durationChangeFunction        function of the including scn
  ///                               called when the duration +/-
  ///                               button is pressed or when the
  ///                               duration value is changed.
  /// transferDataMap               used to fill the display selection
  ///                               popup menu

  AddSubtractResultableDuration({
    required String dateTimeTitle,
    required double topSelMenuPosition,
    required String startDateTimeStr,
    required AddSubtractResultableDuration? nextAddSubtractResultableDuration,
    required String durationStr,
    required int durationSign,
    required TransferDataViewModel transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
  })  : _dateTimeTitle = dateTimeTitle,
        _topSelMenuPosition = topSelMenuPosition,
        durationStr = durationStr,
        _durationSign = durationSign,
        _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap;

  /// this variable enables the CustomStatefullWidget instance to
  /// call the updateWidgetValues() method of its
  /// _CustomStatefullWidgetState instance in order to transmit
  /// to this instance the modified widget data.
  late final _AddSubtractResultableDurationState stateInstance;

  @override
  State<AddSubtractResultableDuration> createState() {
    stateInstance = _AddSubtractResultableDurationState();

    return stateInstance;
  }

  String get endDateTimeStr => _dateTimePickerController.text;

  void handleDurationChange({String? durationStr, int? durationSign}) {
    print('$durationSign $durationStr');
  }

  void handleEndDateTimeChange(String endDateTimeStr) {
    print(endDateTimeStr);
  }
}

class _AddSubtractResultableDurationState
    extends State<AddSubtractResultableDuration> {

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  IconData _durationIcon = Icons.add;
  Color _durationIconColor = _AddSubtractResultableDurationState.durationPositiveColor;
  Color _durationTextColor = _AddSubtractResultableDurationState.durationPositiveColor;

  @override
  Widget build(BuildContext context) {
    widget.durationTextFieldController.text = widget.durationStr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: widget.labelTextStyle,
        ),
        Stack(
          children: [
            Positioned(
              left: -18,
              top: -10,
              child: TextButton.icon(
                icon: Icon(
                  _durationIcon,
                  size: 30,
                  color: _durationIconColor,
                ),
                label: const Text(''),
                onPressed: () {
                  int durationSign;

                  if (_durationIcon == Icons.add) {
                    _durationIcon = Icons.remove;
                    _durationIconColor =
                        _AddSubtractResultableDurationState.durationNegativeColor;
                    durationSign = -1;
                    _durationTextColor =
                        _AddSubtractResultableDurationState.durationNegativeColor;
                  } else {
                    _durationIcon = Icons.add;
                    _durationIconColor =
                        _AddSubtractResultableDurationState.durationPositiveColor;
                    durationSign = 1;
                    _durationTextColor =
                        _AddSubtractResultableDurationState.durationPositiveColor;
                  }

                  widget.handleDurationChange(durationSign: durationSign);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 4, 0, 0), // val
//                                          4 is compliant with current value 5
//                                          of APP_LABEL_TO_TEXT_DISTANCE
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: widget.selectionColor,
                    cursorColor: ScreenMixin.appTextAndIconColor,
                  ),
                ),
                child: GestureDetector(
                  child: TextField(
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                        color: _durationTextColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    keyboardType: TextInputType.datetime,
                    controller: widget.durationTextFieldController,
                    onChanged: (val) {
                      widget.handleDurationChange(durationStr: val);
                    },
                  ),
                  onDoubleTap: () async {
                    await widget.copyToClipboard(
                        context: context,
                        controller: widget.durationTextFieldController);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: kVerticalFieldDistance, // required for correct Now and Sel
          //                                 buttons positioning.
        ),
        EditableDateTime(
          dateTimeTitle: widget._dateTimeTitle,
          dateTimePickerController: widget._dateTimePickerController,
          handleDateTimeModificationFunction:
              widget.handleEndDateTimeChange,
          transferDataMap: widget._transferDataMap,
          handleSelectedDateTimeStrFunction:
              widget.handleEndDateTimeChange,
          topSelMenuPosition: widget._topSelMenuPosition,
          transferDataViewModel: widget._transferDataViewModel,
        ),
      ],
    );
  }
}
