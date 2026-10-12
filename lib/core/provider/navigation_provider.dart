import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class NavigationState {
  const NavigationState();
}

class NavigationHome extends NavigationState {
  const NavigationHome();
}

class NavigationCategory extends NavigationState {
  const NavigationCategory();
}

class NavigationProfile extends NavigationState {
  const NavigationProfile();
}

class NavigationOrder extends NavigationState {
  const NavigationOrder();
}

class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    return const NavigationHome();
  }

  void goToPage(NavigationState state) {
    this.state = state;
  }
}

final navigationProvder = NotifierProvider<NavigationNotifier, NavigationState>(
  NavigationNotifier.new,
);

class NavigationItem {
  const NavigationItem({
    required this.label,
    required this.icon,
    required this.state,
  });

  final String label;
  final String icon;
  final NavigationState state;
}
