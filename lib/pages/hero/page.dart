import 'dart:io';

import 'package:effective_internship/pages/hero/controller.dart';
import 'package:effective_internship/widgets/text/hero_caption.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeroPage extends StatelessWidget {
  HeroPage({Key? key}) : super(key: key);


  final _controller = Get.find<HeroPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // backgroundColor: Color(0x44000000),
        elevation: 0,
        // title: Text("Title"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: Image.file(File(_controller.args.imageUrl)).image,
        )),
        child: Hero(
          tag: 'caption${_controller.args.heroId}',
          child: HeroCaption(
            _controller.args.heroName,
          ),
        ),
      ),
    );
  }
}
