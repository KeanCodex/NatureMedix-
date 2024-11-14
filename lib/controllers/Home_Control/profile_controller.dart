import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/cust_ConfirmAlert.dart';
import '../../routes/screen_routes.dart';
import '../../utils/_initApp.dart';
import '../Auth_Control/login_controller.dart';

class ProfileController extends GetxController {
  final LoginController sp = Get.put(LoginController());

  // Show confirmation dialog for logout
  void showLogoutConfirmation(BuildContext context) {
    showConfirmValidation(
      context,
      'Logout',
      'Are you sure you want to logout?',
      () async {
        sp.userSignOut();
        Get.offAllNamed(ScreenRouter.getLoginRoute);
      },
      Application().gif.question,
    );
    update();
  }

  // Profile options
  List<Map<String, dynamic>> profileData = [];

  @override
  void onInit() {
    super.onInit();

    profileData = [
      {'icon': Icons.edit, 'label': 'Edit Profile', 'action': () {}},
      {'icon': Icons.history, 'label': 'History', 'action': () {}},
      {
        'icon': Icons.lock,
        'label': 'Privacy Policy',
        'action': () => Get.toNamed(ScreenRouter.getPrivacyRoute)
      },
      {
        'icon': Icons.question_answer,
        'label': 'FAQ\'s',
        'action': () => Get.toNamed(ScreenRouter.getFaqRoute)
      },
      {
        'icon': Icons.info_outline,
        'label': 'About Us',
        'action': () => Get.toNamed(ScreenRouter.getAboutRoute)
      },
      {
        'icon': Icons.logout,
        'label': 'Logout',
        'action': () => showLogoutConfirmation(Get.context!)
      },
    ];
  }
}
