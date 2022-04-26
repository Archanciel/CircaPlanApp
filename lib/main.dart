import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:intl/intl.dart';


import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Circadian App';

    return MaterialApp(
      title: appTitle,
      home: MyCustomForm(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('fr', 'CH')], //, Locale('pt', 'BR')],
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;


  late DateFormat _dateTimeFormat;
  late DateFormat _dateOnlyFormat;

  //String _initialValue = '';
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved4 = '';

  String? _wakeUpDT;
  String? _awakeHHmm;
  String? _goToBedDT;
  String? _outputText;

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String _initialValue = dateTimeNow.toString();
    final String localName = 'fr_CH';
    Intl.defaultLocale = localName;
    _dateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
    _dateOnlyFormat = DateFormat("dd-MM-yyyy");

    _controller1 = TextEditingController(text: _initialValue);
    _controller2 = TextEditingController(text: _initialValue);
    _controller3 = TextEditingController(text: _initialValue);

    String lsHour = dateTimeNow.hour.toString().padLeft(2, '0');
    String lsMinute = dateTimeNow.minute.toString().padLeft(2, '0');
    _controller4 = TextEditingController(text: '$lsHour:$lsMinute');
  }

  String? _validateDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid dd-mm hh:mm wake up date time';
    } else {
      List<String?> dateTimeStrLst = DateTimeParser.parseDDMMDateTime(value);
      if (dateTimeStrLst.contains(null)) {
        return 'Please enter a valid dd-mm hh:mm wake up date time';
      }
    }

    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid hh:mm wake up duration';
    } else {
      String? timeStr = DateTimeParser.parseTime(value);
      if (timeStr == null) {
        return 'Please enter a valid hh:mm wake up duration';
      }
    }

    return null;
  }

  String _reformatDateTimeStr(String dateTimeStr) => (dateTimeStr != '')
      ? _dateTimeFormat.format(DateTime.parse(dateTimeStr))
      : '';
  String _reformatDateStr(String dateTimeStr) => (dateTimeStr != '')
      ? _dateOnlyFormat.format(DateTime.parse(dateTimeStr))
      : '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.yellow[300],
          title: const Text('Circadian App'),
        ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'dd MMM yyyy',
                use24HourFormat: true,
                controller: _controller1,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (val) => setState(() => _valueChanged1 = val),
                validator: (val) {
                  setState(() => _valueToValidate1 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: MyInputDecoration(
                  labelText: 'Wake up at',
                  hintText: 'dd-mm hh:mm',
                ),
                keyboardType: TextInputType.datetime,
                // The validator receives the text that the user has entered.
                validator: (value) => _validateDateTime(value),
                onSaved: (String? value) => _wakeUpDT = value,
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: MyInputDecoration(
                  labelText: 'Stay awake',
                  hintText: 'hh:mm',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) => _validateTime(value),
                onSaved: (String? value) => _awakeHHmm = value,
              ),
              TextFormField(
                decoration: MyInputDecoration(
                  labelText: 'Go to bed at',
                  hintText: 'dd-mm hh:mm',
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) => _validateDateTime(value),
                onSaved: (String? value) => _goToBedDT = value,
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
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _outputText ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyInputDecoration extends InputDecoration {
  MyInputDecoration({required String labelText, required String hintText})
      : super(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          hintStyle: const TextStyle(
            color: Colors.white70,
          ),
          errorStyle: const TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.yellow, style: BorderStyle.solid),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
        );
}
