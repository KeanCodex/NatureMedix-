import 'package:get/get.dart';
import 'package:naturemedix/screens/pages/bookmark_screen.dart';
import 'package:naturemedix/screens/pages/control_screen.dart';
import 'package:naturemedix/screens/pages/home_screens.dart';
import 'package:naturemedix/screens/pages/scanner_screen.dart';
import 'package:naturemedix/screens/pages/request_screen.dart';
import 'package:naturemedix/screens/pages/profile_screen.dart';
import 'package:naturemedix/screens/onboarding/getstatrted_screen.dart';
import 'package:naturemedix/screens/splash/splash_screen.dart';
import 'package:naturemedix/screens/authentication/loginAuth_screen.dart';
import 'package:naturemedix/screens/authentication/registerAuth_screen.dart';
import 'package:naturemedix/screens/onboarding/onboarding_screen.dart';
import '../screens/authentication/forgetpass_screen.dart';
import '../screens/pages/gridlist_screen.dart';
import '../screens/pages/plantInfo_screen.dart';
import '../screens/pages/remedy_screen.dart';
import '../screens/pages/search_screen.dart';

class ScreenRouter {
  static const _dashboard = '/dashboard';
  static const _control = '/control';
  static const _bookmark = '/bookmark';
  static const _scanner = '/scanner';
  static const _request = '/request';
  static const _profile = '/profile';
  static const _splash = '/splash';
  static const _getstarted = '/started';
  static const _onboarding = '/onboard';
  static const _login = '/login';
  static const _register = '/register';
  static const _plantInfo = '/plantInfo';
  static const _remedyInfo = '/remedyInfo';
  static const _search = '/search';
  static const _forgetpassword = '/forgetpassword';
  static const _gridlist = '/gridlist';

  static String get getSplashscreenRoute => _splash;
  static String get getControlscreenRoute => _control;
  static String get getBookmarkRoute => _bookmark;
  static String get getScannerRoute => _scanner;
  static String get getRequestRoute => _request;
  static String get getProfileRoute => _profile;
  static String get getGetstartedRoute => _getstarted;
  static String get getOnboardingRoute => _onboarding;
  static String get getLoginRoute => _login;
  static String get getRegisterRoute => _register;
  static String get getPlantInfoRoute => _plantInfo;
  static String get getRemedyInfoRoute => _remedyInfo;
  static String get getDashboardRoute => _dashboard;
  static String get getSearchRoute => _search;
  static String get getGridListRoute => _gridlist;
  static String get getForgetPasswordRoute => _forgetpassword;

  static List<GetPage> routes = [
    GetPage(
      name: _splash,
      page: () => SplashScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _control,
      page: () => ControlScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _bookmark,
      page: () => BookmarkScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _scanner,
      page: () => ScannerScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _request,
      page: () => RequestScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _profile,
      page: () => ProfileScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _getstarted,
      page: () => GetstartedScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _onboarding,
      page: () => OnboardingScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _login,
      page: () => LoginScreen(),
      preventDuplicates: true,
    ),
    GetPage(
      name: _register,
      page: () => RegisterScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _plantInfo,
      page: () => PlantInfoScreen(
        plant: Get.arguments,
      ),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _dashboard,
      page: () => DashboardScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _remedyInfo,
      page: () => RemedyInfoScreen(
        remedy: Get.arguments,
      ),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _search,
      page: () => const SearchScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _forgetpassword,
      page: () => ForgetPasswordScreen(),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
    GetPage(
      name: _gridlist,
      page: () => GridlistScreen(
        title: Get.arguments['title'],
        plantList: Get.arguments['plantList'],
      ),
      preventDuplicates: true,
      transitionDuration: 500.milliseconds,
    ),
  ];
}
