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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _controller.obx((value) {
        if (_controller.status.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_controller.status.isError) {
          return Center(
            child: Text(
              _controller.status.errorMessage ?? 'Неизвестная ошибка',
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: Image.file(File(_controller.image)).image,
          )),
          child: Hero(
            tag: 'caption${_controller.heroId}',
            child: HeroCaption(
              _controller.heroName,
            ),
          ),
        );
      },),
    );
  }
}
