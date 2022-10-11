import 'package:effective_internship/constants/assets.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() async {
    super.initState();
  }

  Widget _pageView() {
    return PageView(

    );
  }

  Widget _title() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Text(
        'Choose your hero',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Image.asset(
        Assets.marvelLogo,
        width: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _logo(),
          _title(),
          Expanded(
            child: _pageView(),
          ),
        ],
      ),
    );
  }
}
