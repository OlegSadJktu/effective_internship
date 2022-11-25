import 'package:effective_internship/database/database.dart';
import 'package:effective_internship/pages/enter_page.dart';
import 'package:effective_internship/pages/hero/bindings.dart';
import 'package:effective_internship/pages/hero/page.dart';
import 'package:effective_internship/pages/main_page/bindings.dart';
import 'package:effective_internship/pages/main_page/page.dart';
import 'package:effective_internship/themes/dark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: '/main',
          page: MainPage.new,
          binding: MainPageBindings(),
        ),
        GetPage(
          name: '/hero',
          page: HeroPage.new,
          binding: HeroPageBindings(),
        ),
      ],
      initialRoute: '/main',
      // home: const MainPage(),
    );
  }
}
