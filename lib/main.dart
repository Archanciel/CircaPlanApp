import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Circadian App';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.yellow[300],
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
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

  String? _wakeUpDT;
  String? _awakeHHmm;
  String? _goToBedDT;
  String? _outputText;

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 20,),
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
