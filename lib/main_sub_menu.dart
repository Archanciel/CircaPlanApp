import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nested PopupMenuButton Example'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Handle the outermost menu selection here
              },
              itemBuilder: (BuildContext context) {
                return {'Menu 1'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Row(
                      children: [
                        Text(choice),
                        Expanded(
                          child: PopupMenuButton<String>(
                            onSelected: (String value) {
                              // Handle the second-level menu selection here
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Submenu 1'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Row(
                                    children: [
                                      Text(choice),
                                      Expanded(
                                        child: PopupMenuButton<String>(
                                          onSelected: (String value) {
                                            // Handle the third-level menu selection here
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return {'Sub-submenu 1', 'Sub-submenu 2'}.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Nested PopupMenuButton Example'),
        ),
      ),
    );
  }
}
