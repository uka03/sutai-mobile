import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/shared/toasts.dart';
import 'package:sutai/page/cart/provider/cart_provider.dart';
import 'package:sutai/page/product/components/product_detail_content.dart';
import 'package:sutai/page/product/provider/product_detail_provider.dart';
import 'package:sutai/page/wishlist/provider/wishlist_provider.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key, required this.productId});

  static const path = '/product/:id';

  final int productId;

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productDetail = ref.watch(productDetailProvider(widget.productId));
    final product = productDetail.valueOrNull?.data;
    final wishlist = ref.watch(wishlistProvider);
    final isFavorite = wishlist.valueOrNull?.any(
          (savedProduct) => savedProduct.id == widget.productId,
        ) ??
        false;

    return GeneralScaffold(
      appBar: CustomAppBar(
        titleCenter: true,
        title: Text(
          'Барааны мэдээлэл',
          style: GeneralTextStyle.titleText(fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        action: [
          IconButton(
            tooltip: 'Хадгалах',
            onPressed: product == null
                ? null
                : () async {
                    try {
                      final added = await ref
                          .read(wishlistProvider.notifier)
                          .toggle(product);
                      if (context.mounted) {
                        Toast.success(
                          context,
                          description: added
                              ? 'Хүслийн жагсаалтад нэмлээ.'
                              : 'Хүслийн жагсаалтаас хаслаа.',
                        );
                      }
                    } catch (_) {
                      if (context.mounted) {
                        Toast.error(
                          context,
                          description: 'Өөрчлөлтийг хадгалж чадсангүй.',
                        );
                      }
                    }
                  },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? GeneralColors.primaryColor : null,
            ),
          ),
        ],
      ),
      bottomBar: product == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProductAddToCartButton(
                  product: product,
                  quantity: _quantity,
                  onTap: () {
                    ref
                        .read(cartProvider.notifier)
                        .addProduct(product, quantity: _quantity);
                    Toast.success(context, description: 'Сагсанд нэмлээ.');
                  },
                ),
              ),
            ),
      child: RefreshIndicator(
        color: GeneralColors.primaryColor,
        backgroundColor: GeneralColors.primaryBGColor,
        onRefresh: () async {
          ref.invalidate(productDetailProvider(widget.productId));
          try {
            await ref.read(productDetailProvider(widget.productId).future);
          } catch (_) {}
        },
        child: productDetail.when(
          loading: () => const RefreshableStateView(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => RefreshableStateView(
            child: EmptyStateView(
              icon: Icons.wifi_off_rounded,
              title: 'Барааг татаж чадсангүй',
              message: apiErrorMessage(
                error,
                'Холболтоо шалгаад дахин оролдоно уу.',
              ),
              actionLabel: 'Дахин оролдох',
              onAction: () => ref.invalidate(
                productDetailProvider(widget.productId),
              ),
              compact: true,
            ),
          ),
          data: (detail) => ProductDetailContent(
            product: detail.data,
            relatedProducts: detail.related,
            quantity: _quantity,
            onDecrease: () => setState(() => _quantity--),
            onIncrease: () => setState(() => _quantity++),
          ),
        ),
      ),
    );
  }
}
