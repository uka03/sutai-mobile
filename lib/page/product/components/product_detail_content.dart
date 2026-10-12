import 'package:flutter/material.dart';
import 'package:sutai/core/shared/cached_image.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/page/home/model/product_response.dart';
import 'package:sutai/page/product/components/related_product_section.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({
    super.key,
    required this.product,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    this.relatedProducts = const [],
  });

  final ProductResponse product;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final List<ProductResponse> relatedProducts;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductImage(
          imageUrl:
              product.image?.url ??
              product.image?.preview ??
              product.image?.thumbnail,
        ),
        VSpacer.lg(),
        Text(
          (product.categories.isEmpty
                  ? 'БАРАА'
                  : product.categories.map((category) => category.name).join(', '))
              .toUpperCase(),
          style: GeneralTextStyle.bodyText(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            textColor: GeneralColors.primaryColor,
          ),
        ),
        VSpacer.sm(),
        Text(
          product.name,
          style: GeneralTextStyle.titleText(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        VSpacer.sm(),
        Row(
          children: [
            Text(
              formatPrice(product.price),
              style: GeneralTextStyle.titleText(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                textColor: GeneralColors.primaryColor,
              ),
            ),
          ],
        ),
        VSpacer.lg(),
        const Divider(color: GeneralColors.borderColor),
        VSpacer.sm(),
        Text('Тоо ширхэг', style: GeneralTextStyle.titleText(fontSize: 15)),
        VSpacer.sm(),
        Row(
          children: [
            _QuantityButton(
              icon: Icons.remove,
              onPressed: quantity > 1 ? onDecrease : null,
            ),
            SizedBox(
              width: 52,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: GeneralTextStyle.titleText(fontSize: 17),
              ),
            ),
            _QuantityButton(icon: Icons.add, onPressed: onIncrease),
          ],
        ),
        VSpacer.lg(),
        Text('Барааны тухай', style: GeneralTextStyle.titleText(fontSize: 17)),
        VSpacer.sm(),
        Text(
          product.description == null || product.description!.isEmpty
              ? 'Тайлбар оруулаагүй байна.'
              : product.description!,
          style: GeneralTextStyle.bodyText(
            fontSize: 15,
            height: 1.55,
            textColor: GeneralColors.textGrayColor,
          ),
        ),
        VSpacer.lg(),
        const Divider(color: GeneralColors.borderColor),
        VSpacer.sm(),
        _ProductInformation(product: product),
        if (relatedProducts.isNotEmpty) ...[
          VSpacer.xl(),
          RelatedProductSection(products: relatedProducts),
        ],
      ],
    ),
  );

}

class ProductAddToCartButton extends StatelessWidget {
  const ProductAddToCartButton({
    super.key,
    required this.product,
    required this.quantity,
    required this.onTap,
  });

  final ProductResponse product;
  final int quantity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => CustomButton(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GeneralColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          HSpacer.sm(),
          Text(
            'Сагсанд нэмэх · ${formatPrice(product.price * quantity)}',
            style: GeneralTextStyle.titleText(textColor: Colors.white),
          ),
        ],
      ),
    ),
  );

}

class _ProductInformation extends StatelessWidget {
  const _ProductInformation({required this.product});

  final ProductResponse product;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Бүтээгдэхүүний мэдээлэл',
        style: GeneralTextStyle.titleText(fontSize: 17),
      ),
      VSpacer.sm(),
      _ProductInfoRow(label: 'Барааны дугаар', value: '#${product.id}'),
      if (product.createdAt case final createdAt?)
        _ProductInfoRow(
          label: 'Нэмэгдсэн огноо',
          value:
              '${createdAt.year.toString().padLeft(4, '0')}-'
              '${createdAt.month.toString().padLeft(2, '0')}-'
              '${createdAt.day.toString().padLeft(2, '0')}',
        ),
      if (product.categories.isNotEmpty) ...[
        VSpacer.md(),
        Text('Ангилал', style: GeneralTextStyle.titleText(fontSize: 14)),
        VSpacer.xs(),
        for (final category in product.categories) ...[
          Text(
            category.name,
            style: GeneralTextStyle.bodyText(fontWeight: FontWeight.w600),
          ),
          if (category.description case final description?)
            Text(
              description,
              style: GeneralTextStyle.bodyText(
                textColor: GeneralColors.textGrayColor,
              ),
            ),
          _ProductInfoRow(label: 'Ангиллын дугаар', value: '${category.id}'),
        ],
      ],
      if (product.tags.isNotEmpty) ...[
        VSpacer.md(),
        Text('Шошго', style: GeneralTextStyle.titleText(fontSize: 14)),
        VSpacer.xs(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in product.tags)
              Chip(
                label: Text('${tag.name} · #${tag.id}'),
                backgroundColor: GeneralColors.secondaryBGColor,
                side: const BorderSide(color: GeneralColors.borderColor),
                labelStyle: GeneralTextStyle.bodyText(fontSize: 12),
              ),
          ],
        ),
      ],
    ],
  );
}

class _ProductInfoRow extends StatelessWidget {
  const _ProductInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GeneralTextStyle.bodyText(
              textColor: GeneralColors.textGrayColor,
            ),
          ),
        ),
        HSpacer.md(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GeneralTextStyle.bodyText(
              fontWeight: FontWeight.w600,
              textColor: GeneralColors.textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.08,
    child: imageUrl == null
        ? const _ImagePlaceholder()
        : CachedImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            borderRadius: 24,
          ),
  );
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: GeneralColors.inputColor,
      borderRadius: BorderRadius.circular(24),
    ),
    child: const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 76,
        color: GeneralColors.primaryColor,
      ),
    ),
  );
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton.outlined(
    onPressed: onPressed,
    icon: Icon(icon),
    color: GeneralColors.primaryColor,
    style: IconButton.styleFrom(
      side: const BorderSide(color: GeneralColors.borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
