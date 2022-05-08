import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/date_time_difference_duration.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:intl/intl.dart';

class CalculateSleepDuration extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;

  const CalculateSleepDuration({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
  })  : _screenNavigTransData = screenNavigTransData,
        super(key: key);

  @override
  _CalculateSleepDurationState createState() {
    return _CalculateSleepDurationState(_screenNavigTransData.transferDataMap);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _CalculateSleepDurationState extends State<CalculateSleepDuration>
    with ScreenMixin {
  _CalculateSleepDurationState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _transferDataMap;
  String _status = 'Sleep';

  late TextEditingController _newDateTimeController;

  final DateFormat _frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  //String _initialValue = '';
  String? _wakeUpDT;
  String? _awakeHHmm;
  String? _goToBedDT;
  String? _outputText;

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();

    _newDateTimeController =
        TextEditingController(text: _frenchDateTimeFormat.format(dateTimeNow));
  }

  Map<String, dynamic> _createTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    return map;
  }

  String _reformatDateTimeStr(String englishDateTimeStr) =>
      (englishDateTimeStr != '')
          ? _frenchDateTimeFormat.format(DateTime.parse(englishDateTimeStr))
          : '';

  void _modifyNewDateTimeMinute({required int minuteNb}) {
    DateTime newDateTime =
        _frenchDateTimeFormat.parse(_newDateTimeController.text);

    if (minuteNb > 0) {
      newDateTime = newDateTime.subtract(Duration(minutes: -minuteNb));
    } else {
      newDateTime = newDateTime.add(Duration(minutes: minuteNb));
    }

    setState(() {
      _newDateTimeController.text = _frenchDateTimeFormat.format(newDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: Container(
        width: MediaQuery.of(context).size.width *
            ScreenMixin.appDrawerWidthProportion,
        child: Drawer(
          backgroundColor: Colors.blue[300],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: ScreenMixin.appDrawerHeaderHeight,
                child: DrawerHeader(
                  child: Text(
                    ScreenMixin.appDrawerHeaderText,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appDrawerFontWeight,
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.blue),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                title: const Text(
                  ScreenMixin.addDurationToDateTimeTitle,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: ScreenMixin.appDrawerTextFontSize,
                    fontWeight: ScreenMixin.appDrawerFontWeight,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddDurationToDateTime(
                        screenNavigTransData: ScreenNavigTransData(
                            transferDataMap: _createTransferDataMap()),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                title: const Text(
                  ScreenMixin.dateTimeDiffDurationTitle,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: ScreenMixin.appDrawerTextFontSize,
                    fontWeight: ScreenMixin.appDrawerFontWeight,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DateTimeDifferenceDuration(
                        screenNavigTransData: ScreenNavigTransData(
                            transferDataMap: _createTransferDataMap()),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: appLabelColor,
        title: const Text(ScreenMixin.calculateSleepDurationTitle),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height:
                          15, // same distance from Appbar than the other screens
                    ),
                    Text(
                      'New date time',
                      style: TextStyle(
                        color: appLabelColor,
                        fontSize: ScreenMixin.appTextFontSize,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: TextField(
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            style: TextStyle(
                                color: appTextAndIconColor,
                                fontSize: ScreenMixin.appTextFontSize,
                                fontWeight: ScreenMixin.appTextFontWeight),
                            keyboardType: TextInputType.datetime,
                            controller: _newDateTimeController,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: appElevatedButtonBackgroundColor,
                              shape: appElevatedButtonRoundedShape),
                          onPressed: () {
                            setState(() {
                              _newDateTimeController.text =
                                  _frenchDateTimeFormat.format(DateTime.now());
                            });
                          },
                          child: const Text(
                            'Now',
                            style: TextStyle(
                              fontSize: ScreenMixin.appTextFontSize,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              constraints: const BoxConstraints(
                                minHeight: 0,
                                minWidth: 0,
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                _modifyNewDateTimeMinute(minuteNb: 1);
                              },
                              icon: Icon(
                                Icons.add,
                                color: appTextAndIconColor,
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(
                                minHeight: 0,
                                minWidth: 0,
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                _modifyNewDateTimeMinute(minuteNb: -1);
                              },
                              icon: Icon(
                                Icons.remove,
                                color: appTextAndIconColor,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: appElevatedButtonBackgroundColor,
                              shape: appElevatedButtonRoundedShape),
                          onPressed: () {
                            setState(() {
                              print('Add button pressed');
                            });
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: ScreenMixin.appTextFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Stored date time',
                      style: TextStyle(
                        color: appLabelColor,
                        fontSize: ScreenMixin.appTextFontSize,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: TextField(
                            style: TextStyle(
                                color: appTextAndIconColor,
                                fontSize: ScreenMixin.appTextFontSize,
                                fontWeight: ScreenMixin.appTextFontWeight),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              contentPadding: EdgeInsets.fromLTRB(0, 17, 0, 0),
                              labelStyle: TextStyle(
                                fontSize: ScreenMixin.appTextFontSize,
                                color: appTextAndIconColor,
                                fontWeight: ScreenMixin.appTextFontWeight,
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            controller: _newDateTimeController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Current sleep duration',
                      style: TextStyle(
                        color: appLabelColor,
                        fontSize: ScreenMixin.appTextFontSize,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: TextField(
                            style: TextStyle(
                                color: appTextAndIconColor,
                                fontSize: ScreenMixin.appTextFontSize,
                                fontWeight: ScreenMixin.appTextFontWeight),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              contentPadding: EdgeInsets.fromLTRB(0, 17, 0, 0),
                              labelStyle: TextStyle(
                                fontSize: ScreenMixin.appTextFontSize,
                                color: appTextAndIconColor,
                                fontWeight: ScreenMixin.appTextFontWeight,
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            controller: _newDateTimeController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(''),
                Container(
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () {
                setState(() {
                  if (_status == 'Wake up') {
                    _status = 'Sleep';
                  } else {
                    _status = 'Wake up';
                  }
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: ScreenMixin.appTextFontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
