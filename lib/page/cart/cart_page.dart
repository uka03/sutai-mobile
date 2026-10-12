import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/cart/components/cart_item_tile.dart';
import 'package:sutai/page/cart/provider/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  static const path = '/cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return GeneralScaffold(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      appBar: CustomAppBar(
        titleCenter: true,
        title: Text('Миний сагс', style: GeneralTextStyle.titleText(fontSize: 18)),
        action: [
          if (!cart.isEmpty)
            IconButton(
              tooltip: 'Сагс хоослох',
              onPressed: cartNotifier.clear,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      bottomBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cart.itemCount} бараа',
                                style: GeneralTextStyle.bodyText(
                                  fontSize: 12,
                                  textColor: GeneralColors.textGrayColor,
                                ),
                              ),
                              VSpacer.xs(),
                              Text(
                                formatPrice(cart.total),
                                style: GeneralTextStyle.titleText(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: GeneralColors.primaryColor,
                        ),
                        HSpacer.xs(),
                      ],
                    ),
                    VSpacer.sm(),
                    CustomButton(
                      onTap: () => context.push('/checkout'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: GeneralColors.primaryColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Захиалга үүсгэх',
                            style: GeneralTextStyle.titleText(
                              fontSize: 15,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      child: cart.isEmpty
          ? EmptyStateView(
              icon: Icons.shopping_bag_outlined,
              title: 'Сагс хоосон байна',
              message: 'Таалагдсан бараагаа сагсандаа нэмээд эндээс захиалаарай.',
              actionLabel: 'Бараа үзэх',
              onAction: () => context.go('/main'),
            )
          : ListView.separated(
              itemCount: cart.items.length,
              separatorBuilder: (context, index) => VSpacer.sm(),
              itemBuilder: (context, index) {
                final entry = cart.items[index];
                return CartItemTile(
                  entry: entry,
                  onDecrease: entry.quantity > 1
                      ? () => cartNotifier.decrease(entry.product.id)
                      : null,
                  onIncrease: () => cartNotifier.increase(entry.product.id),
                  onRemove: () => cartNotifier.removeProduct(entry.product.id),
                );
              },
            ),
    );
  }

}
