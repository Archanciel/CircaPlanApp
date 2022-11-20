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

  final String widgetPrefixOrName;

  ManuallySelectableTextField({
    super.key,
    required TransferDataViewModel transferDataViewModel,
    required this.textFieldController,
    required this.handleTextFieldChangeFunction,
    this.widgetPrefixOrName = '',
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataViewModel.getTransferDataMap() ?? {};

  @override
  State<ManuallySelectableTextField> createState() {
    stateInstance = _ManuallySelectableTextFieldState(
        transferDataViewModel: _transferDataViewModel,
        transferDataMap: _transferDataMap,
        textFieldController: textFieldController,
        handleTextFieldChangeFunction: handleTextFieldChangeFunction,
        widgetPrefixOrName: widgetPrefixOrName);

    return stateInstance;
  }

  TextEditingController? get controller => textFieldController;

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
  Color _durationTextColor;

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
    String widgetPrefixOrName = '',
  })  : _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap,
        _durationTextColor =
            transferDataMap['${widgetPrefixOrName}DurationTextColor'] ??
                ScreenMixin.APP_TEXT_AND_ICON_COLOR;

  @override
  void initState() {
    super.initState();

    textFieldController.text =
        _transferDataMap[_getTextFieldKey()] ?? '00:00:00';
  }

  /// Since the ManuallySelectableTextField is used for 1st screen
  /// 3 Duration text fields in the DurationDateTimeEditor and for
  /// 4th screen 2 Time text fields, in the 2 cases, constructing
  /// the textFieldValueKey is specific to the ManuallySelectableTextField
  /// usage. The logic is located in this method.
  String _getTextFieldKey() {
    if (_transferDataMap.containsKey(widget.widgetPrefixOrName)) {
      return widget.widgetPrefixOrName;
    } else {
      String textFieldValueKey = '${widget.widgetPrefixOrName}DurationStr';
      if (_transferDataMap.containsKey(textFieldValueKey)) {
        return textFieldValueKey;
      } else {
        return '';
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // HitTestBehavior intercepts all pointer calls. Required,
      // otherwise GestureDetector.onTap:, onDoubleTap:,
      // onLongPress: not applied
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(
        // Prevents displaying copy menu after selecting in
        // TextField.
        // Required for onLongPress selection to work
        child: TextField(
          key: const Key('manuallySelectableTextField'),
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
