import 'package:effective_internship/pages/main_page/controller.dart';
import 'package:effective_internship/repo/characters_repository.dart';
import 'package:get/get.dart';

class MainPageBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(MainPageController.new)
      ..lazyPut(CharactersRepository.new);
  }
}
