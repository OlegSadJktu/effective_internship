import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:effective_internship/constants/assets.dart';
import 'package:effective_internship/pages/hero/args.dart';
import 'package:effective_internship/pages/main_page/controller.dart';
import 'package:effective_internship/widgets/text/hero_caption.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = CarouselController();

  final _controller = Get.find<MainPageController>();

  Widget _pageView() {
    if (_controller.heroes.isEmpty) {
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
        onPageChanged: (index, _) => _controller.notifyActivePageChanged(index),
      ),
      items: _controller.heroes.map((hero) {
        return Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/hero',
                      arguments: HeroPageArgs(
                        heroId: hero.id,
                        imageUrl: hero.thumbnailUrl,
                        heroName: hero.name,
                      ));
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
                          File(hero.thumbnailUrl),
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
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.refresh),
        onPressed: () {
          _controller.onInit();
        }
      ),
      body: SafeArea(
        child: Obx(
          () {
            return Stack(
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
                        color: _controller.getColor(),
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
            );
          },
        ),
      ),
    );
  }
}
