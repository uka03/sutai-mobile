import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/home/provider/product_search_provider.dart';
import 'package:sutai/page/home/components/product_search_filter_sheet.dart';

class ProductSearchControls extends ConsumerWidget {
  const ProductSearchControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productSearchProvider);
    final notifier = ref.read(productSearchProvider.notifier);
    final activeCount = [
      if (state.categoryId != null) true,
      if (state.tagId != null) true,
      if (state.minPrice.isNotEmpty) true,
      if (state.maxPrice.isNotEmpty) true,
    ].length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _ProductSearchField(initialValue: state.search)),
              HSpacer.sm(),
              Badge(
                isLabelVisible: activeCount > 0,
                label: Text('$activeCount'),
                child: IconButton.filledTonal(
                  tooltip: 'Шүүлтүүр',
                  onPressed: () => ProductSearchFilterSheet.show(context),
                  icon: const Icon(Icons.tune_rounded),
                  style: IconButton.styleFrom(
                    foregroundColor: GeneralColors.primaryColor,
                    backgroundColor: GeneralColors.primaryColor.withAlpha(22),
                  ),
                ),
              ),
              HSpacer.xs(),
              PopupMenuButton<String>(
                tooltip: 'Эрэмбэлэх',
                initialValue: state.sort,
                onSelected: notifier.updateSort,
                color: GeneralColors.primaryBGColor,
                surfaceTintColor: Colors.transparent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: GeneralColors.borderColor),
                ),
                offset: const Offset(0, 8),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'newest',
                    child: _SortMenuLabel(
                      label: 'Шинэ',
                      selected: state.sort == 'newest',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'price_asc',
                    child: _SortMenuLabel(
                      label: 'Үнэ: багаас их',
                      selected: state.sort == 'price_asc',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'price_desc',
                    child: _SortMenuLabel(
                      label: 'Үнэ: ихээс бага',
                      selected: state.sort == 'price_desc',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'name',
                    child: _SortMenuLabel(
                      label: 'Нэр',
                      selected: state.sort == 'name',
                    ),
                  ),
                ],
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: GeneralColors.secondaryBGColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: GeneralColors.borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swap_vert_rounded,
                        size: 20,
                        color: GeneralColors.textColor,
                      ),
                      HSpacer.xs(),
                      Text(
                        _sortLabel(state.sort),
                        style: GeneralTextStyle.bodyText(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: GeneralColors.textColor,
                        ),
                      ),
                      HSpacer.xs(),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: GeneralColors.textGrayColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (activeCount > 0) ...[
            VSpacer.sm(),
            Wrap(
              spacing: 8,
              children: [
                if (state.tagId != null)
                  _FilterChip(
                    label:
                        state.tags
                            .where((tag) => tag.id == state.tagId)
                            .firstOrNull
                            ?.name ??
                        'Шошго ${state.tagId}',
                    onDeleted: notifier.clearTag,
                  ),
                if (state.categoryId != null)
                  _FilterChip(
                    label:
                        state.categories
                            .where(
                              (category) => category.id == state.categoryId,
                            )
                            .firstOrNull
                            ?.name ??
                        'Ангилал ${state.categoryId}',
                    onDeleted: notifier.clearCategory,
                  ),
                if (state.minPrice.isNotEmpty)
                  _FilterChip(
                    label: 'Үнэ ≥ ${state.minPrice} ₮',
                    onDeleted: notifier.clearMinPrice,
                  ),
                if (state.maxPrice.isNotEmpty)
                  _FilterChip(
                    label: 'Үнэ ≤ ${state.maxPrice} ₮',
                    onDeleted: notifier.clearMaxPrice,
                  ),
              ],
            ),
          ],
          if (state.totalCount != null) ...[
            VSpacer.sm(),
            Text(
              'Нийт ${state.totalCount} бараа',
              style: GeneralTextStyle.bodyText(
                fontSize: 13,
                textColor: GeneralColors.textGrayColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _sortLabel(String sort) => switch (sort) {
    'price_asc' => 'Үнэ ↑',
    'price_desc' => 'Үнэ ↓',
    'name' => 'Нэр',
    _ => 'Шинэ',
  };
}

class _SortMenuLabel extends StatelessWidget {
  const _SortMenuLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: GeneralTextStyle.bodyText(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            textColor: selected
                ? GeneralColors.primaryColor
                : GeneralColors.textColor,
          ),
        ),
      ),
      if (selected)
        const Icon(
          Icons.check_rounded,
          size: 18,
          color: GeneralColors.primaryColor,
        ),
    ],
  );
}

class _ProductSearchField extends ConsumerStatefulWidget {
  const _ProductSearchField({required this.initialValue});

  final String initialValue;

  @override
  ConsumerState<_ProductSearchField> createState() =>
      _ProductSearchFieldState();
}

class _ProductSearchFieldState extends ConsumerState<_ProductSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(productSearchProvider.notifier);
    return TextField(
      controller: _controller,
      onChanged: notifier.updateSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Барааны нэрээр хайх',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _controller.clear();
                  notifier.clearSearch();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
        filled: true,
        fillColor: GeneralColors.inputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) => InputChip(
    label: Text(label),
    onDeleted: onDeleted,
    deleteIconColor: GeneralColors.primaryColor,
    backgroundColor: GeneralColors.primaryColor.withAlpha(18),
    side: BorderSide.none,
    labelStyle: GeneralTextStyle.bodyText(fontSize: 12),
  );
}
