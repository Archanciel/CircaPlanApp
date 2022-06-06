import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget with ScreenMixin {
  final void Function() _onPress;

  ResetButton({
    required void Function() onPress,
    Key? key,
  })  : _onPress = onPress,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 10,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: appElevatedButtonBackgroundColor,
            shape: appElevatedButtonRoundedShape),
        onPressed: _onPress,
        child: const Text(
          'Reset',
          style: TextStyle(
            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
          ),
        ),
      ),
    );
  }
}
