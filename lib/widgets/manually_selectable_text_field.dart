import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import '../buslog/transfer_data_view_model.dart';

class ManuallySelectableTextField extends StatefulWidget {
  final TransferDataViewModel _transferDataViewModel;
  final Map<String, dynamic> _transferDataMap;

  late final _ManuallySelectableTextFieldState stateInstance;
  late final TextEditingController textFieldController;

  final void Function([
    String? textFieldStr,
    int? durationSign,
    bool? wasDurationSignButtonPressed,
  ]) handleTextFieldChangeFunction;

  final String widgetName;

  ManuallySelectableTextField({
    super.key,
    required TransferDataViewModel transferDataViewModel,
    required this.textFieldController,
    required this.handleTextFieldChangeFunction,
    this.widgetName = '',
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataViewModel.getTransferDataMap() ?? {};

  @override
  State<ManuallySelectableTextField> createState() {
    stateInstance = _ManuallySelectableTextFieldState(
        transferDataViewModel: _transferDataViewModel,
        transferDataMap: _transferDataMap,
        textFieldController: textFieldController,
        handleTextFieldChangeFunction: handleTextFieldChangeFunction,
        widgetName: widgetName);

    return stateInstance;
  }

  Color getTextColor() {
    return stateInstance.getTextColor();
  }

  void setTextColor(Color textColor) {
    stateInstance.setTextColor(textColor);
  }
}

class _ManuallySelectableTextFieldState
    extends State<ManuallySelectableTextField> with ScreenMixin {
  final TransferDataViewModel _transferDataViewModel;
  final Map<String, dynamic> _transferDataMap;
  final _textfieldFocusNode = FocusNode();
  Color _durationTextColor = Colors.green.shade200;

  late final TextEditingController textFieldController;

  final void Function([
    String? textFieldStr,
    int? durationSign,
    bool? wasDurationSignButtonPressed,
  ]) handleTextFieldChangeFunction;

  _ManuallySelectableTextFieldState({
    required TransferDataViewModel transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
    required this.textFieldController,
    required this.handleTextFieldChangeFunction,
    String widgetName = '',
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap,
        _durationTextColor =
            transferDataMap['${widgetName}DurationTextColor'] ?? Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String nowStr = ScreenMixin.englishDateTimeFormat.format(DateTime.now());
    _transferDataMap["addDurStartDateTimeStr"] = nowStr;
    _transferDataMap["firstStartDateTimeStr"] = nowStr;
    _transferDataMap["firstEndDateTimeStr"] = nowStr;

    textFieldController.text =
        _transferDataMap['${widget.widgetName}DurationStr'] ?? '00:00:00';
  }

  @override
  void dispose() {
    _textfieldFocusNode.dispose();

    super.dispose();
  }

  Color getTextColor() {
    return _durationTextColor;
  }

  void setTextColor(Color textColor) {
    _durationTextColor = textColor;

    setState(() {}); // WARNING: setState() method must not be
    //                           called a second time in the
    //                           setTextColor() calling code in
    //                           order to avoid "Field
    //                           'stateInstance'has not been
    //                           initialized" error !
  }

  void _updateTransferDataMap() {
    _transferDataMap['${widget.widgetName}DurationStr'] = textFieldController.text;

    _transferDataViewModel.updateAndSaveTransferData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(
        // Prevents displaying copy menu after selecting in
        // TextField.
        // Required for onLongPress selection to work
        child: TextField(
          key: const Key('durationTextField'),
          // Required, otherwise, field not focusable due to
          // IgnorePointer wrapping
          focusNode: _textfieldFocusNode,
          decoration: const InputDecoration.collapsed(hintText: ''),
          style: TextStyle(
              color: _durationTextColor,
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
          keyboardType: TextInputType.datetime,
          controller: textFieldController,
          onSubmitted: (val) {
            // solve the unsolvable problem of onChange()
            // which set cursor at TextField start position !
            handleTextFieldChangeFunction(val);
          },
        ),
      ),
      onTap: () {
        // Required, otherwise, duration field not focusable
        FocusScope.of(context).requestFocus(
          _textfieldFocusNode,
        );

        // Positioning the cursor to the end of TextField content.
        // WARNING: works only if keyboard is displayed or other
        // duration field is in edit mode !
        textFieldController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: textFieldController.text.length,
          ),
        );
      },
      onDoubleTap: () async {
        await handleClipboardDataDurationDateTimeEditor(
            context: context,
            textEditingController: textFieldController,
            transferDataMap: _transferDataViewModel.getTransferDataMap()!,
            handleDataChangeFunction: handleTextFieldChangeFunction);
      },
      onLongPress: () {
        // Requesting focus avoids necessity to first tap on
        // TextField before long pressing on it to select its
        // content !
        FocusScope.of(context).requestFocus(
          _textfieldFocusNode,
        );
        textFieldController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textFieldController.text.length,
        );
      },
    );
  }
}
