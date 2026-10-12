import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/page/home/components/product_search_controls.dart';
import 'package:sutai/page/home/components/product_search_results.dart';
import 'package:sutai/page/home/provider/product_search_provider.dart';

class ProductSearchPage extends ConsumerStatefulWidget {
  const ProductSearchPage({super.key, this.initialTagId, this.initialCategoryId});

  static const path = '/search';
  final int? initialTagId;
  final int? initialCategoryId;

  @override
  ConsumerState<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends ConsumerState<ProductSearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(productSearchProvider.notifier)
          .initialize(
            initialTagId: widget.initialTagId,
            initialCategoryId: widget.initialCategoryId,
          );
    });
  }

  @override
  Widget build(BuildContext context) => GeneralScaffold(
    padding: EdgeInsets.zero,
    appBar: const CustomAppBar(
      title: Text('Бараа хайх'),
      bgColor: Colors.white,
    ),
    child: Column(
      children: [
        const ProductSearchControls(),
        Expanded(child: const ProductSearchResults()),
      ],
    ),
  );
}
