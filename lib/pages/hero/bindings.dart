import 'package:effective_internship/pages/hero/controller.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:get/get.dart';

class HeroPageBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(HeroPageController.new)
      ..lazyPut(CharactersRepository.new);
  }
}
