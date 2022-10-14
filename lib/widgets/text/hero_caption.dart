import 'package:flutter/material.dart';

class HeroCaption extends StatelessWidget {

  const HeroCaption( this.text, {
    Key? key
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: DefaultTextStyle(
        style: const TextStyle(
          // color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            text,
          ),
        ),
      ),
    );
  }

}
