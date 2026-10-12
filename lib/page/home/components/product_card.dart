import 'package:flutter/material.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/cached_image.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/page/home/model/product_response.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width,
  });

  final ProductResponse product;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: CustomButton(
          onTap: onTap,
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
      ),
    );
  }
}
