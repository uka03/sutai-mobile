import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/constants.dart';
import 'package:sutai/core/provider/navigation_provider.dart';
import 'package:sutai/core/provider/theme_provider.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';
import 'package:sutai/page/category/category_page.dart';
import 'package:sutai/page/home/home_page.dart';
import 'package:sutai/page/cart/provider/cart_provider.dart';
import 'package:sutai/page/order/my_orders_page.dart';
import 'package:sutai/page/profile/profile_page.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  static const String path = "/main";

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(navigationProvder);
    final user = ref.watch(authProvider);
    final cartItemCount = ref.watch(cartProvider).itemCount;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          user is AuthStateAuthenticated
              ? 'Сайн байна уу, ${user.user.name}'
              : AppConst.appName,
          style: GeneralTextStyle.titleText(
            fontSize: 26,
            textColor: GeneralColors.primaryColor,
          ),
        ),
        action: [
          IconButton(
            tooltip: 'Загвар солих',
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          CustomButton(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: GeneralColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      top: -7,
                      right: -8,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: GeneralColors.errorColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: GeneralColors.primaryBGColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '$cartItemCount',
                          style: GeneralTextStyle.bodyText(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            onTap: () => context.push('/cart'),
          ),
          IconButton(
            tooltip: 'Хүслийн жагсаалт',
            onPressed: () => context.push('/wishlist'),
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: GeneralColors.primaryColor,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? GeneralColors.darkGrayBGColor
          : GeneralColors.grayBGColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: navigationItems.map((item) {
            return NavButton(
              item: item,
              isSelected: state == item.state,
              onpress: (item) {
                ref.read(navigationProvder.notifier).goToPage(item.state);
              },
            );
          }).toList(),
        ),
      ),
      body: switch (state) {
        NavigationHome() => HomePage(),
        NavigationCategory() => CategoryPage(),
        NavigationOrder() => const MyOrdersPage(),
        NavigationProfile() => const ProfilePage(),
      },
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.item,
    this.isSelected = false,
    required this.onpress,
  });

  final NavigationItem item;
  final bool isSelected;
  final Function(NavigationItem item) onpress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomButton(
        onTap: () {
          onpress(item);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: isSelected
              ? GeneralColors.primaryColor
              : Theme.of(context).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                item.icon,
                color: isSelected ? Colors.white : GeneralColors.textGrayColor,
                height: 30,
              ),
              VSpacer.xs(),
              Text(
                item.label,
                style: GeneralTextStyle.bodyText(
                  fontSize: 12,
                  textColor: isSelected
                      ? Colors.white
                      : GeneralColors.textGrayColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
