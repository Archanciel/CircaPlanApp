import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DateTimePicker Demo',
      home: MyHomePage(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('fr', 'CH')], //, Locale('pt', 'BR')],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;

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

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    //_initialValue = DateTime.now().toString();
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _controller2 = TextEditingController(text: DateTime.now().toString());
    _controller3 = TextEditingController(text: DateTime.now().toString());

    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
    _controller4 = TextEditingController(text: '$lsHour:$lsMinute');

    _getValue();
  }

  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API
  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = '2000-10-22 14:30';
        _controller1.text = '26-4-2022 14:30';
        _controller2.text = '26-4-2022 15:31';
        _controller3.text = '26-4-2022';
        _controller4.text = '17:01';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter DateTimePicker Demo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Form(
          key: _oFormKey,
          child: Column(
            children: <Widget>[
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'dd MMM, yyyy',
                locale: Locale('fr', 'CH'),
                use24HourFormat: true,
                controller: _controller1,
                //initialValue: _initialValue,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  if (date.weekday == 6 || date.weekday == 7) {
                    return false;
                  }
                  return true;
                },
                onChanged: (val) => setState(() => _valueChanged1 = val),
                validator: (val) {
                  setState(() => _valueToValidate1 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
              ),
              const SizedBox(
                height: 20,
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'dd-MM-yyyy HH:mm',
                locale: const Locale('fr', 'CH'),
                use24HourFormat: true,
                controller: _controller2,
                //initialValue: _initialValue,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                //icon: Icon(Icons.event),
                dateLabelText: 'Date Time',
                onChanged: (val) => setState(() => _valueChanged2 = val),
                validator: (val) {
                  setState(() => _valueToValidate2 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
              ),
              const SizedBox(
                height: 20,
              ),
              DateTimePicker(
                type: DateTimePickerType.date,
                //dateMask: 'yyyy/MM/dd',
                controller: _controller3,
                //initialValue: _initialValue,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                locale: Locale('fr', 'CH'),
                onChanged: (val) => setState(() => _valueChanged3 = val),
                validator: (val) {
                  setState(() => _valueToValidate3 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved3 = val ?? ''),
              ),
              DateTimePicker(
                type: DateTimePickerType.time,
                //timePickerEntryModeInput: true,
                //controller: _controller4,
                initialValue: '', //_initialValue,
                icon: Icon(Icons.access_time),
                timeLabelText: "Time",
                use24HourFormat: true,
                locale: Locale('fr', 'CH'),
                onChanged: (val) => setState(() => _valueChanged4 = val),
                validator: (val) {
                  setState(() => _valueToValidate4 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved4 = val ?? ''),
              ),
              SizedBox(height: 20),
              Text(
                'DateTimePicker data value onChanged:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(_valueChanged1),
              SelectableText(_valueChanged2),
              SelectableText(_valueChanged3),
              SelectableText(_valueChanged4),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final loForm = _oFormKey.currentState;

                  if (loForm?.validate() == true) {
                    loForm?.save();
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 30),
              Text(
                'DateTimePicker data value validator:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(_valueToValidate1),
              SelectableText(_valueToValidate2),
              SelectableText(_valueToValidate3),
              SelectableText(_valueToValidate4),
              SizedBox(height: 10),
              Text(
                'DateTimePicker data value onSaved:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(_valueSaved1),
              SelectableText(_valueSaved2),
              SelectableText(_valueSaved3),
              SelectableText(_valueSaved4),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final loForm = _oFormKey.currentState;
                  loForm?.reset();

                  setState(() {
                    _valueChanged1 = '';
                    _valueChanged2 = '';
                    _valueChanged3 = '';
                    _valueChanged4 = '';
                    _valueToValidate1 = '';
                    _valueToValidate2 = '';
                    _valueToValidate3 = '';
                    _valueToValidate4 = '';
                    _valueSaved1 = '';
                    _valueSaved2 = '';
                    _valueSaved3 = '';
                    _valueSaved4 = '';
                  });

                  _controller1.clear();
                  _controller2.clear();
                  _controller3.clear();
                  _controller4.clear();
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
