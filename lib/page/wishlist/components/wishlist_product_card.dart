import 'package:flutter/material.dart';
import 'package:sutai/core/shared/cached_image.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/core/navigation/product_navigation.dart';
import 'package:sutai/page/home/model/product_response.dart';

class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard({
    super.key,
    required this.product,
    required this.onRemove,
  });

  final ProductResponse product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          CustomButton(
            onTap: () => openProduct(context, product),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: product.image?.preview == null
                          ? const SizedBox(
                              width: double.infinity,
                              child: ColoredBox(
                                color: GeneralColors.inputColor,
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: GeneralColors.primaryColor,
                                  size: 36,
                                ),
                              ),
                            )
                          : CachedImage(
                              imageUrl: product.image!.preview!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              borderRadius: 12,
                            ),
                    ),
                  ),
                  VSpacer.sm(),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GeneralTextStyle.bodyText(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  VSpacer.xs(),
                  Text(
                    formatPrice(product.price),
                    style: GeneralTextStyle.titleText(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textColor: GeneralColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: Material(
              color: Colors.white.withValues(alpha: 0.94),
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Хадгалснаас хасах',
                onPressed: onRemove,
                icon: const Icon(
                  Icons.favorite,
                  color: GeneralColors.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
