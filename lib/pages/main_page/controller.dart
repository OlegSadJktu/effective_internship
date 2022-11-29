import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:effective_internship/constants/paths.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:effective_internship/pages/hero/args.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rxdart/rxdart.dart';

final pushNotificationsHandler = BehaviorSubject<RemoteMessage>();

class MainPageController extends GetxController {
  final _repo = Get.put(CharactersRepository());
  final heroes = <Character>[].obs;
  final colors = <Color?>[].obs;
  final activePageIndex = 0.obs;
  final images = <Image>[].obs;

  bool _isFetching = false;

  Future<void> printToken() async {
    final a = await FirebaseMessaging.instance.getToken();
    log('token => $a',);
  }

  Future<void> fetchHeroes(int offset) async {
    if (_isFetching) {
      return;
    }
    _isFetching = true;
    try {
      final newHeroes = await _repo.fetchCharacters(offset);
      heroes.addAll(newHeroes);
    } on DioError catch (e, s) {
      print(e.response);
    } finally {
      _isFetching = false;
    }

  }

  @override
  void onInit() {

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _openHero(int.parse(event.data['id'] as String));
    });

    pushNotificationsHandler.stream.listen((event) {
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
    await Get.toNamed(
      Paths.heroPage,
      arguments: HeroPageArgs(
        heroId: id,
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
    if (pageIndex + 3 > heroes.length) {
      fetchHeroes(heroes.length);
    }
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
