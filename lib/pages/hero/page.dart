import 'package:effective_internship/widgets/text/hero_caption.dart';
import 'package:flutter/material.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({
    Key? key,
    required this.heroId,
    required this.imageUrl,
    required this.heroName,
  }) : super(key: key);

  final int heroId;
  final String imageUrl;
  final String heroName;

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
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
          image: Image.network(widget.imageUrl).image,
        )),
        child: Hero(
          tag: 'caption${widget.heroId}',
          child: HeroCaption(
            widget.heroName,
          ),
        ),
      ),
    );
  }
}
