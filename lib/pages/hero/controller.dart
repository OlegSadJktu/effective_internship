import 'package:effective_internship/pages/hero/args.dart';
import 'package:get/get.dart';

class HeroPageController extends GetxController {

  late HeroPageArgs args;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;
  }

}
