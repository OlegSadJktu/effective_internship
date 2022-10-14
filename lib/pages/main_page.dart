import 'package:effective_internship/constants/assets.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:effective_internship/pages/hero/page.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:effective_internship/widgets/text/hero_caption.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final CharactersRepository _repo = Get.put(CharactersRepository());
  final PageController _pageController = PageController(viewportFraction: 0.8);

  List<Character>? _characters;
  List<ImageProvider>? _images;

  @override
  void initState() {
    super.initState();
    _repo.getCharacters().then((value) {
      setState(() {
        _characters = value;
        _images = List.from(value.map((e) => Image.network(e.thumbnailUrl!).image));
      });
    },);

  }

  Widget _pageView() {
    if (_characters == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return PageView(
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      children: List.generate(_characters!.length, (index) {
        final hero = _characters![index];
        return Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HeroPage(
                      heroId: hero.id,
                      imageUrl: hero.thumbnailUrl!,
                      heroName: hero.name,
                    );
                  }));
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
                        image: _images![index],// Image.network(e.thumbnailUrl!).image
                      ),
                    ),
                    child: Hero(
                      tag: 'caption${_characters![index].id}',
                      child: HeroCaption(_characters![index].name)
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        );

      }),


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
    return Scaffold(
      backgroundColor: const Color(0xff2A2629),
      body: SafeArea(
        child: Column(
          children: [
            _logo(),
            _title(),
            Expanded(
              child: _pageView(),
            ),
          ],
        ),
      ),
    );
  }
}
