import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/navigation/product_navigation.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/custom_text_field.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/offline_state_view.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/home/components/product_card.dart';
import 'package:sutai/page/home/model/tag_products_response.dart';
import 'package:sutai/page/home/provider/tag_products_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedProducts = ref.watch(tagProductsProvider);
    return GeneralScaffold(
      child: RefreshIndicator(
        color: GeneralColors.primaryColor,
        backgroundColor: GeneralColors.primaryBGColor,
        onRefresh: () async {
          ref.invalidate(tagListProvider);
          ref.invalidate(tagProductsProvider);
          await ref.read(tagProductsProvider.future);
        },
        child: groupedProducts.when(
          loading: () =>
              const RefreshableStateView(child: CircularProgressIndicator()),
          error: (error, stack) =>
              error is DioException &&
                  (error.type == DioExceptionType.connectionError ||
                      error.type == DioExceptionType.connectionTimeout ||
                      error.type == DioExceptionType.receiveTimeout)
              ? OfflineStateView(
                  onRetry: () {
                    ref.invalidate(tagListProvider);
                    ref.invalidate(tagProductsProvider);
                  },
                )
              : RefreshableStateView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        apiErrorMessage(error, 'Бараа татахад алдаа гарлаа.'),
                      ),
                      VSpacer.xs(),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(tagListProvider);
                          ref.invalidate(tagProductsProvider);
                        },
                        child: const Text('Дахин оролдох'),
                      ),
                    ],
                  ),
                ),
          data: (groups) => _HomeContent(groups: groups),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.groups});

  final List<TagProductsResponse> groups;

  @override
  Widget build(BuildContext context) {
    final nonEmptyGroups = groups
        .where((group) => group.products.isNotEmpty)
        .toList();
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Text(
          'Өнөөдөр юу хайж байна?',
          style: GeneralTextStyle.titleText(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        VSpacer(),
        CustomButton(
          onTap: () => context.push('/search'),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: TextEditingController(),
              hintText: 'Бараа хайх',
            ),
          ),
        ),
        VSpacer.lg(),
        if (nonEmptyGroups.isEmpty)
          const EmptyStateView(
            icon: Icons.inventory_2_outlined,
            title: 'Бараа одоогоор алга',
            message: 'Шинэ бараанууд нэмэгдэхэд энд харагдана.',
          ),
        for (final group in nonEmptyGroups) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  group.tagName,
                  style: GeneralTextStyle.titleText(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/search?tag_id=${group.tagId}'),
                style: TextButton.styleFrom(
                  foregroundColor: GeneralColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('(${group.tagCount}) Бүгд'),
              ),
            ],
          ),
          VSpacer.sm(),
          SizedBox(
            height: 222,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: group.products.length,
              separatorBuilder: (context, index) => HSpacer.sm(),
              itemBuilder: (context, index) {
                final product = group.products[index];
                return ProductCard(
                  product: product,
                  width: 154,
                  onTap: () => openProduct(context, product),
                );
              },
            ),
          ),
          VSpacer.xl(),
        ],
      ],
    );
  }
}
