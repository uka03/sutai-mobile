import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';
import 'package:sutai/page/category/components/category_page_content.dart';
import 'package:sutai/page/category/provider/category_provider.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    return GeneralScaffold(
      padding: EdgeInsets.zero,
      child: RefreshIndicator(
        color: GeneralColors.primaryColor,
        backgroundColor: GeneralColors.primaryBGColor,
        onRefresh: () async {
          ref.invalidate(categoryProvider);
          try {
            await ref.read(categoryProvider.future);
          } catch (_) {
            // The provider's error state displays the refresh failure.
          }
        },
        child: categories.when(
          loading: () => const RefreshableStateView(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => RefreshableStateView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  apiErrorMessage(error, 'Ангилал татахад алдаа гарлаа.'),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(categoryProvider),
                  child: const Text('Дахин оролдох'),
                ),
              ],
            ),
          ),
          data: (categories) => CategoryPageContent(categories: categories),
        ),
      ),
    );
  }
}
