import 'package:effective_internship/models/marvel/character.dart';



class HeroPageArgs {
  const HeroPageArgs({
    this.heroId,
    this.hero,
  }) : assert((heroId != null) ^ (hero != null),
  'Only id or hero must not be null');

  final int? heroId;
  final Character? hero;

  bool get heroIsObject => hero != null;

}
