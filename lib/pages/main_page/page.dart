import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:effective_internship/constants/assets.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:effective_internship/pages/hero/args.dart';
import 'package:effective_internship/pages/hero/page.dart';
import 'package:effective_internship/pages/main_page/controller.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:effective_internship/widgets/text/hero_caption.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final CharactersRepository _repo = Get.put(CharactersRepository());
  final _pageController = CarouselController();

  List<Character>? _characters;
  List<Image>? _images;
  late int _currentColorIndex;
  final List<Color?> _colors = [];
  static int a = 0;

  // final _controller = Get.find<MainPageController>();

  Future<PaletteGenerator> _getPalette(Image image) async {
    a += 1;
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      image.image,
      size: Size(10, 20),
      maximumColorCount: 1,
    );
    return paletteGenerator;
  }

  @override
  void initState() {
    super.initState();
    _currentColorIndex = 0;
    _repo.getCharacters().then(
      (value) {
        setState(() {
          _characters = value;
          _colors
            ..clear()
            ..addAll(Iterable.generate(
                _characters!.length,
                (e) => Colors
                    .transparent)); //..fillRange(0, _characters!.length, Colors.red);
          _images = List.from(value.map((e) => Image.file(File(e.thumbnailUrl!))));
          _updateColors();
        });
      },
    );
  }

  Future<void> _updateColors() async {
    if (_images!.isEmpty) {
      return;
    }
    final palette = await _getPalette(_images![0]);
    setState(() {
      _colors[0] = palette.dominantColor?.color;
    });
    for (var i = 1; i < _images!.length; i++) {
      final palette = await _getPalette(_images![i]);
      _colors[i] = palette.dominantColor?.color;
    }
    setState(() {});
  }

  void _updatePage(int page) {
    if (_colors.isEmpty) {
      return;
    }
    setState(() {
      _currentColorIndex = page;
    });
  }

  Widget _pageView() {
    if (_characters == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return CarouselSlider(
      carouselController: _pageController,
      options: CarouselOptions(
        viewportFraction: 0.77,
        scrollPhysics: const BouncingScrollPhysics(),
        enlargeCenterPage: true,
        aspectRatio: 8 / 15,
        enableInfiniteScroll: false,
        onPageChanged: (index, _) => _updatePage(index),
      ),
      items: _characters!.map((hero) {
        print('url => ${hero.thumbnailUrl}');
        return Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    '/hero',
                    arguments: HeroPageArgs(
                      heroId: hero.id,
                      imageUrl: hero.thumbnailUrl!,
                      heroName: hero.name,
                    )
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: Image.file(
                          File(hero.thumbnailUrl!),
                          // loadingBuilder: (context, _, __) {
                          //   return const Center(
                          //       child: CircularProgressIndicator());
                          // },
                        ).image,
                      ),
                    ),
                    child: Hero(
                      tag: 'caption${hero.id}',
                      child: HeroCaption(hero.name),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        );
      }).toList(),
    );
  }

  Widget _title() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Text(
        'Choose your hero',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 25,
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
    final size = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: const Color(0xff2A2629),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              top: size.height / 2,
              left: 0,
              right: 0,
              child: Diagonal(
                clipHeight: (size.height - 2 * safeAreaPadding.top) / 2,
                position: DiagonalPosition.TOP_RIGHT,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: _colors.isNotEmpty
                        ? _colors[_currentColorIndex]
                        : Colors.transparent, // const Color(0xff2A2629),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _logo(),
                _title(),
                Expanded(
                  child: _pageView(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}