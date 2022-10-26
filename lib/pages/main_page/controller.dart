import 'package:effective_internship/models/marvel/character.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {

  final heroes = <Character>[].obs;
  final _repo = Get.put(CharactersRepository());

  @override
  void onInit() {

    _repo.getCharacters().then((value) {
      heroes.value = value;
    });
    super.onInit();
  }

}
