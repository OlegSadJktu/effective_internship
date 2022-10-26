import 'package:effective_internship/pages/hero/controller.dart';
import 'package:get/get.dart';

class HeroPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HeroPageController.new);
  }

}
