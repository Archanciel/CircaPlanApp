import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class IncreaseSleepTime extends StatefulWidget {
  const IncreaseSleepTime({Key? key}) : super(key: key);

  @override
  State<IncreaseSleepTime> createState() => _IncreaseSleepTimeState();
}

class _IncreaseSleepTimeState extends State<IncreaseSleepTime> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        NumberInputPrefabbed.squaredButtons(
          controller: TextEditingController(),
          incDecBgColor: Colors.blue,
        ),
        NumberInputPrefabbed.squaredButtons(
          controller: TextEditingController(),
          incDecBgColor: Colors.blue,
        ),
      ]),
    );
  }
}
