import 'package:get/get.dart';
import 'package:naturemedix/controllers/onboarding_controller.dart';

class InitDep implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies'
    Get.lazyPut(() => OnboardingController());
  }
}