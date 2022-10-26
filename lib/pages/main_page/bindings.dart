import 'package:effective_internship/pages/main_page/controller.dart';
import 'package:get/get.dart';

class MainPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MainPageController.new);
  }

}
