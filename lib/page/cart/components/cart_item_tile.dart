import 'package:flutter/material.dart';
import 'package:sutai/core/shared/cached_image.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/page/cart/model/cart_entry.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.entry,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  final CartEntry entry;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: GeneralColors.primaryBGColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: GeneralColors.borderColor),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 76,
            height: 88,
            child:
                (entry.product.image?.preview ??
                        entry.product.image?.url ??
                        entry.product.image?.thumbnail) ==
                    null
                ? const ColoredBox(
                    color: GeneralColors.secondaryBGColor,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: GeneralColors.primaryColor,
                    ),
                  )
                : CachedImage(
                    imageUrl:
                        entry.product.image!.preview ??
                        entry.product.image!.url ??
                        entry.product.image!.thumbnail!,
                    width: 76,
                    height: 88,
                    fit: BoxFit.cover,
                    borderRadius: 12,
                  ),
          ),
        ),
        HSpacer.sm(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GeneralTextStyle.titleText(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    tooltip: 'Сагснаас хасах',
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: GeneralColors.textGrayColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
              VSpacer.xs(),
              Text(
                '${formatPrice(entry.product.price)} / ширхэг',
                style: GeneralTextStyle.bodyText(
                  fontSize: 12,
                  textColor: GeneralColors.textGrayColor,
                ),
              ),
              VSpacer.sm(),
              Row(
                children: [
                  _QuantityControl(icon: Icons.remove, onTap: onDecrease),
                  HSpacer.sm(),
                  Text(
                    '${entry.quantity}',
                    style: GeneralTextStyle.titleText(fontSize: 14),
                  ),
                  HSpacer.sm(),
                  _QuantityControl(icon: Icons.add, onTap: onIncrease),
                  const Spacer(),
                  Text(
                    formatPrice(entry.subtotal),
                    style: GeneralTextStyle.titleText(
                      fontSize: 14,
                      textColor: GeneralColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: GeneralColors.secondaryBGColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 17, color: GeneralColors.textColor),
    );
    if (onTap == null) return Opacity(opacity: 0.4, child: button);
    return CustomButton(
      onTap: onTap!,
      borderRadius: BorderRadius.circular(9),
      child: button,
    );
  }
}
