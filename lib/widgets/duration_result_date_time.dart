import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/widgets/result_date_time.dart';

class DurationResultDateTime extends StatefulWidget {
  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final TextEditingController _resultDateTimeController;
  final TextEditingController _durationTextFieldController;
  final Function _updateTransferDataMap;
  final Function _durationChangeFunction;

  IconData _durationIcon;
  Color _durationIconColor;
  Color _durationTextColor;
  int _durationSign;

  DurationResultDateTime({
    required TextEditingController resultDateTimeController,
    required TextEditingController durationTextFieldController,
    required Function updateTransferDataMapFunction,
    required Function durationChangeFunction,
    required IconData durationIcon,
    required Color durationIconColor,
    required Color durationTextColor,
    required int durationSign,
  })  : _resultDateTimeController = resultDateTimeController,
        _durationTextFieldController = durationTextFieldController,
        _updateTransferDataMap = updateTransferDataMapFunction,
        _durationChangeFunction = durationChangeFunction,
        _durationIcon = durationIcon,
        _durationIconColor = durationIconColor,
        _durationTextColor = durationTextColor,
        _durationSign = durationSign;

  @override
  State<DurationResultDateTime> createState() => _DurationResultDateTimeState(
        resultDateTimeController: _resultDateTimeController,
        durationTextFieldController: _durationTextFieldController,
        updateTransferDataMapFunction: _updateTransferDataMap,
        durationChangeFunction: _durationChangeFunction,
        durationIcon: _durationIcon,
        durationIconColor: _durationIconColor,
        durationTextColor: _durationTextColor,
        durationSign: _durationSign,
      );
}

class _DurationResultDateTimeState extends State<DurationResultDateTime>
    with ScreenMixin {
  Color _durationTextColor;
  final TextEditingController _resultDateTimeController;
  final TextEditingController _durationTextFieldController;
  final Function _updateTransferDataMap;
  final Function _durationChangeFunction;

  IconData _durationIcon;
  Color _durationIconColor;
  int _durationSign;

  _DurationResultDateTimeState({
    required TextEditingController resultDateTimeController,
    required TextEditingController durationTextFieldController,
    required Function updateTransferDataMapFunction,
    required Function durationChangeFunction,
    required IconData durationIcon,
    required Color durationIconColor,
    required Color durationTextColor,
    required int durationSign,
  })  : _resultDateTimeController = resultDateTimeController,
        _durationTextFieldController = durationTextFieldController,
        _updateTransferDataMap = updateTransferDataMapFunction,
        _durationChangeFunction = durationChangeFunction,
        _durationIcon = durationIcon,
        _durationIconColor = durationIconColor,
        _durationTextColor = durationTextColor,
        _durationSign = durationSign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duration',
            style: TextStyle(
              color: appLabelColor,
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
            ),
          ),
          Stack(
            children: [
              Positioned(
                left: -18,
                top: -10,
                child: TextButton.icon(
                  icon: Icon(
                    widget._durationIcon,
                    size: 30,
                    color: widget._durationIconColor,
                  ),
                  label: const Text(''),
                  onPressed: () {
                    if (widget._durationIcon == Icons.add) {
                      _durationIcon = Icons.remove;
                      _durationIconColor =
                          DurationResultDateTime.durationNegativeColor;
                      _durationSign = -1;
                      _durationTextColor =
                          DurationResultDateTime.durationNegativeColor;
                    } else {
                      _durationIcon = Icons.add;
                      _durationIconColor =
                          DurationResultDateTime.durationPositiveColor;
                      _durationSign = 1;
                      _durationTextColor =
                          DurationResultDateTime.durationPositiveColor;
                    }
                    _durationChangeFunction(_durationSign);
                    setState(() {
                      
                    });
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
                      selectionColor: selectionColor,
                      cursorColor: appTextAndIconColor,
                    ),
                  ),
                  child: TextField(
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                        color: _durationTextColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    keyboardType: TextInputType.datetime,
                    controller: widget._durationTextFieldController,
                    onChanged: (val) {
                      widget._durationChangeFunction();
                    },
                  ),
                ),
              ),
            ],
          ),
          ResultDateTime(
            resultDateTimeController: widget._resultDateTimeController,
            updateTransferDataMapFunction: widget._updateTransferDataMap,
          ),
        ],
      ),
    );
  }
}
