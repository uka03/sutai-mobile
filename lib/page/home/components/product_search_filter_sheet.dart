import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/home/provider/product_search_provider.dart';

class ProductSearchFilterSheet extends ConsumerStatefulWidget {
  const ProductSearchFilterSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (_) => const ProductSearchFilterSheet(),
  );

  @override
  ConsumerState<ProductSearchFilterSheet> createState() =>
      _ProductSearchFilterSheetState();
}

class _ProductSearchFilterSheetState
    extends ConsumerState<ProductSearchFilterSheet> {
  late int? _categoryId;
  late int? _tagId;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(productSearchProvider);
    _categoryId = state.categoryId;
    _tagId = state.tagId;
    _minPriceController = TextEditingController(text: state.minPrice);
    _maxPriceController = TextEditingController(text: state.maxPrice);
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productSearchProvider);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Шүүлтүүр',
                      style: GeneralTextStyle.titleText(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _categoryId = null;
                        _tagId = null;
                        _minPriceController.clear();
                        _maxPriceController.clear();
                      });
                    },
                    child: const Text('Цэвэрлэх'),
                  ),
                ],
              ),
              VSpacer.sm(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _ExpandableFilterSection(
                      title: 'Ангилал',
                      selectedLabel: state.categories
                          .where((item) => item.id == _categoryId)
                          .firstOrNull
                          ?.name,
                      children: [
                        RadioGroup<int?>(
                          groupValue: _categoryId,
                          onChanged: (value) =>
                              setState(() => _categoryId = value),
                          child: Column(
                            children: [
                              const _OptionRadioTile<int?>(
                                value: null,
                                title: 'Бүх ангилал',
                              ),
                              ...state.categories.map(
                                (category) => _OptionRadioTile<int?>(
                                  value: category.id,
                                  title: category.name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _ExpandableFilterSection(
                      title: 'Шошго',
                      selectedLabel: state.tags
                          .where((item) => item.id == _tagId)
                          .firstOrNull
                          ?.name,
                      children: [
                        RadioGroup<int?>(
                          groupValue: _tagId,
                          onChanged: (value) => setState(() => _tagId = value),
                          child: Column(
                            children: [
                              const _OptionRadioTile<int?>(
                                value: null,
                                title: 'Бүх шошго',
                              ),
                              ...state.tags.map(
                                (tag) => _OptionRadioTile<int?>(
                                  value: tag.id,
                                  title: tag.name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    VSpacer.sm(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Доод үнэ',
                              suffixText: '₮',
                            ),
                          ),
                        ),
                        HSpacer.sm(),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Дээд үнэ',
                              suffixText: '₮',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VSpacer.md(),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onTap: () {
                    ref
                        .read(productSearchProvider.notifier)
                        .updateFilters(
                          categoryId: _categoryId,
                          tagId: _tagId,
                          minPrice: _minPriceController.text,
                          maxPrice: _maxPriceController.text,
                        );
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: GeneralColors.primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Хэрэглэх',
                      style: GeneralTextStyle.titleText(
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
    );
  }
}

class _OptionRadioTile<T> extends StatelessWidget {
  const _OptionRadioTile({
    required this.value,
    required this.title,
  });

  final T value;
  final String title;

  @override
  Widget build(BuildContext context) => RadioListTile<T>(
    value: value,
    title: Text(title),
    dense: true,
    contentPadding: EdgeInsets.zero,
    activeColor: GeneralColors.primaryColor,
  );
}

class _ExpandableFilterSection extends StatelessWidget {
  const _ExpandableFilterSection({
    required this.title,
    required this.children,
    this.selectedLabel,
  });

  final String title;
  final String? selectedLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    tilePadding: EdgeInsets.zero,
    childrenPadding: const EdgeInsets.only(left: 4),
    title: Text(title, style: GeneralTextStyle.titleText(fontSize: 16)),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedLabel != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              selectedLabel!,
              style: GeneralTextStyle.bodyText(
                fontSize: 12,
                textColor: GeneralColors.primaryColor,
              ),
            ),
          ),
        const Icon(Icons.expand_more),
      ],
    ),
    children: children,
  );
}
