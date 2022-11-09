import 'dart:io';
import 'dart:math';

import 'package:effective_internship/constants/paths.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:effective_internship/pages/hero/args.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:palette_generator/palette_generator.dart';


class MainPageController extends GetxController {
  final _repo = Get.put(CharactersRepository());
  final heroes = <Character>[].obs;
  final colors = <Color?>[].obs;
  final activePageIndex = 0.obs;
  final images = <Image>[].obs;

  Future<void> printToken() async {
    final a = await FirebaseMessaging.instance.getToken();
    print(a);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    print('asda');
    return;
  }

  @override
  void onInit() {
    print('reload');

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _openHero(int.parse(event.data['id'] as String));
    });

    printToken();
    heroes.clear();
    _repo.getCharacters().then((value) {
      heroes.value = value;
      colors
        ..clear()
        ..addAll(
          Iterable.generate(
            value.length,
            (_) => Colors.transparent,
          ),
        );
      images
        ..clear()
        ..addAll(value.map((e) => Image.file(File(e.thumbnailUrl))).toList());
      _updateColors();
    });
    super.onInit();
  }

  Future<void> _openHero(int id) async {
    // final hero = await _repo.getCharacter(id: id);
    await Get.toNamed(
      Paths.heroPage,
      arguments: HeroPageArgs(
        heroId: id,
        // hero: hero,
      ),
    );
  }

  Color? getColor() {
    if (colors.isEmpty || activePageIndex.value > colors.length) {
      return null;
    }
    return colors[activePageIndex.value];
  }

  void notifyActivePageChanged(int pageIndex) {
    if (colors.isEmpty) {
      return;
    }
    activePageIndex.value = pageIndex;
  }

  Future<void> _updateColors() async {
    if (images.isEmpty) {
      return;
    }
    final palette = await _getPalette(images[0]);
    colors[0] = palette.dominantColor?.color;
    for (var i = 1; i < images.length; i++) {
      final palette = await _getPalette(images[i]);
      colors[i] = palette.dominantColor?.color;
    }
  }

  Future<PaletteGenerator> _getPalette(Image image) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      image.image,
      size: Size(10, 20),
      maximumColorCount: 1,
    );
    return paletteGenerator;
  }
}
