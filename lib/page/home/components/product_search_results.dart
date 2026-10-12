import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/navigation/product_navigation.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/page/home/components/product_card.dart';
import 'package:sutai/page/home/model/product_response.dart';
import 'package:sutai/page/home/provider/product_search_provider.dart';

class ProductSearchResults extends ConsumerWidget {
  const ProductSearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productSearchProvider);
    final notifier = ref.read(productSearchProvider.notifier);
    return RefreshIndicator(
      onRefresh: () async => notifier.refresh(),
      child: PagedGridView<int, ProductResponse>(
        state: state.pagingState,
        fetchNextPage: notifier.fetchNextPage,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        builderDelegate: PagedChildBuilderDelegate<ProductResponse>(
          itemBuilder: (context, product, index) => ProductCard(
            product: product,
            onTap: () => openProduct(context, product),
          ),
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  apiErrorMessage(
                    state.pagingState.error,
                    'Хайлт хийхэд алдаа гарлаа.',
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton.icon(
                  onPressed: notifier.fetchNextPage,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Дахин оролдох'),
                ),
              ],
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => Center(
            child: IconButton(
              onPressed: notifier.fetchNextPage,
              icon: const Icon(Icons.refresh),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => const EmptyStateView(
            icon: Icons.search_off_rounded,
            title: 'Бараа олдсонгүй',
            message: 'Хайлтын үг эсвэл шүүлтүүрээ өөрчлөөд үзээрэй.',
            compact: true,
          ),
        ),
      ),
    );
  }
}
