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

  late TextEditingController _controller1;

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

    _controller1 =
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
    DateTime newDateTime = _frenchDateTimeFormat.parse(_controller1.text);

    if (minuteNb > 0) {
      newDateTime = newDateTime.subtract(Duration(minutes: -minuteNb));
    } else {
      newDateTime = newDateTime.add(Duration(minutes: minuteNb));
    }

    setState(() {
      _controller1.text = _frenchDateTimeFormat.format(newDateTime);
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
        backgroundColor: Colors.blue[900],
        foregroundColor: appLabelColor,
        title: const Text(ScreenMixin.calculateSleepDurationTitle),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
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
                          style: TextStyle(
                              color: appTextAndIconColor,
                              fontSize: ScreenMixin.appTextFontSize,
                              fontWeight: ScreenMixin.appTextFontWeight),
                          keyboardType: TextInputType.datetime,
                          controller: _controller1,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _controller1.text =
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
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      _formKey.currentState!.save();
                      setState(() {
                        _outputText =
                            'Input values: $_wakeUpDT, $_awakeHHmm, $_goToBedDT';
                      });
                      print(
                          'Input values: $_wakeUpDT, $_awakeHHmm, $_goToBedDT');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
