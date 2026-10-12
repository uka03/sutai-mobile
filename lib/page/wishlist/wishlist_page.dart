import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/shared/toasts.dart';
import 'package:sutai/page/wishlist/components/wishlist_product_card.dart';
import 'package:sutai/page/wishlist/provider/wishlist_provider.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  static const path = '/wishlist';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);

    return GeneralScaffold(
      appBar: CustomAppBar(
        title: Text(
          'Хүслийн жагсаалт',
          style: GeneralTextStyle.titleText(fontSize: 19),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      child: wishlist.when(
        loading: () =>
            const RefreshableStateView(child: CircularProgressIndicator()),
        error: (error, stackTrace) => RefreshableStateView(
          child: EmptyStateView(
            icon: Icons.favorite_border_rounded,
            title: 'Жагсаалтыг ачаалж чадсангүй',
            message: 'Дахин оролдоно уу.',
            actionLabel: 'Дахин оролдох',
            onAction: () => ref.invalidate(wishlistProvider),
            compact: true,
          ),
        ),
        data: (products) => products.isEmpty
            ? const EmptyStateView(
                icon: Icons.favorite_border_rounded,
                title: 'Хадгалсан бараа алга',
                message: 'Таалагдсан бараагаа зүрх товчоор хадгалаарай.',
              )
            : GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return WishlistProductCard(
                    product: product,
                    onRemove: () async {
                      await ref
                          .read(wishlistProvider.notifier)
                          .remove(product.id);
                      if (context.mounted) {
                        Toast.success(
                          context,
                          description: 'Хүслийн жагсаалтаас хаслаа.',
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
