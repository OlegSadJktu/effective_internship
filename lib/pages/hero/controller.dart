import 'package:effective_internship/models/marvel/character.dart';
import 'package:effective_internship/pages/hero/args.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:get/get.dart';

class HeroPageController extends GetxController with StateMixin<void> {
  late HeroPageArgs args;

  final _repo = Get.find<CharactersRepository>();
  Character? _hero;

  String get image => _hero!.thumbnailUrl;

  String get heroName => _hero!.name;

  int get heroId => _hero!.id;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;
    if (args.heroIsObject) {
      _hero = args.hero;
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.loading());
      _repo.getCharacter(id: args.heroId!).then((value) {
        _hero = value;
        change(null, status: RxStatus.success());
      }, onError: (err) {
        change(null, status: RxStatus.error(err));
      });
    }
  }
}
