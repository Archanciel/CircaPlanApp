import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
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

  static const labelStyleTextStyle = TextStyle(fontSize: 20);
  static const errorStyleTextStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  String? _firstName;
  String? _lastName;
  String? _outputText;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a non empty name';
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
                decoration: const InputDecoration(
                  labelText: 'First name',
                  labelStyle: labelStyleTextStyle,
                  hintText: 'First name',
                  errorStyle: errorStyleTextStyle,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) => _validateName(value),
                onSaved: (String? value) => _firstName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  labelStyle: labelStyleTextStyle,
                  hintText: 'Last name',
                  errorStyle: errorStyleTextStyle,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) => _validateName(value),
                onSaved: (String? value) => _lastName = value,
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
                        _outputText = '$_firstName $_lastName';
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(_outputText ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
