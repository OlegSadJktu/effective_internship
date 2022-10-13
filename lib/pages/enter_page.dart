import 'package:effective_internship/pages/main_page.dart';
import 'package:flutter/material.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return const MainPage();
              }),
            );
          },
          child: const Text('asd'),
        ),
      ),
    );
  }

}
