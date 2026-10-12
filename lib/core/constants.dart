import 'package:sutai/core/provider/navigation_provider.dart';

class AppConst {
  static const String baseUrl = "https://job.sutainbuyant.com/api/v1";
  static const String tokenKey = "token";
  static const String userKey = "user";
  static const String appName = "Сутай";
}

final List<NavigationItem> navigationItems = [
  const NavigationItem(
    label: 'Нүүр',
    icon: 'assets/icons/ic_home.png',
    state: NavigationHome(),
  ),
  const NavigationItem(
    label: 'Ангилал',
    icon: 'assets/icons/ic_paper.png',
    state: NavigationCategory(),
  ),
  const NavigationItem(
    label: 'Захиалга',
    icon: 'assets/icons/ic_box.png',
    state: NavigationOrder(),
  ),
  const NavigationItem(
    label: 'Профайл',
    icon: 'assets/icons/ic_profile.png',
    state: NavigationProfile(),
  ),
];
