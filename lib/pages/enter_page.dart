import 'package:effective_internship/pages/main_page/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/main');
          },
          child: const Text('Open page'),
        ),
      ),
    );
  }
}
