import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import '../screens/screen_mixin.dart';

class NonEditableDateTime extends StatelessWidget with ScreenMixin {
  NonEditableDateTime({
    Key? key,
    required this.dateTimeTitle,
    required TextEditingController dateTimeController,
    required Map<String, dynamic> transferDataMap,
    this.position = ToastGravity.CENTER,
  })  : _dateTimeController = dateTimeController,
        _transferDataMap = transferDataMap,
        super(key: key);

  final String dateTimeTitle;
  final TextEditingController _dateTimeController;
  final Map<String, dynamic> _transferDataMap;
  final ToastGravity position;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateTimeTitle,
          style: labelTextStyle,
        ),
        const SizedBox(
          height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
        ),
        GestureDetector(
          child: TextField(
            style: valueTextStyle,
            decoration: const InputDecoration.collapsed(hintText: ''),
            // prevents displaying copy paste menu !
            contextMenuBuilder: null,
            controller: _dateTimeController,
            readOnly: true,
          ),
          onDoubleTap: () async {
            await copyToClipboard(
              context: context,
              controller: _dateTimeController,
              extractHHmmFromCopiedStr: true,
              position: position,
            );
            _transferDataMap['clipboardLastAction'] = ClipboardLastAction.copy;
          },
        ),
      ],
    );
  }
}
