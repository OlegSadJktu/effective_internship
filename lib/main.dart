import 'package:effective_internship/database/database.dart';
import 'package:effective_internship/pages/enter_page.dart';
import 'package:effective_internship/pages/main_page.dart';
import 'package:effective_internship/themes/dark.dart';
import 'package:flutter/material.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EnterPage(),
    );
  }
}

