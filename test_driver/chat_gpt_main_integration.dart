// test_driver/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'package:circa_plan/chat_gpt_main.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Create a TransferDataViewModel for the MainApp
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: 'path_to_your_file.json'); // Replace this with a valid path or mock

  // Call the `main()` method of your app or run your app
  runApp(MyApp(transferDataViewModel: transferDataViewModel));
}
