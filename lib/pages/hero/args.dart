class HeroPageArgs {
  const HeroPageArgs({
    required this.heroId,
    required this.imageUrl,
    required this.heroName,
  });

  final int heroId;
  final String imageUrl;
  final String heroName;
}
