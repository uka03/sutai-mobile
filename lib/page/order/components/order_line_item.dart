import 'package:flutter/material.dart';
import 'package:sutai/core/shared/cached_image.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/page/order/model/order_detail_response.dart';

class OrderLineItem extends StatelessWidget {
  const OrderLineItem({super.key, required this.item});

  final OrderItemResponse item;

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item.image?.preview ?? item.image?.thumbnail ?? item.image?.url;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GeneralColors.primaryBGColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 72,
              height: 72,
              child: imageUrl == null
                  ? const ColoredBox(
                      color: GeneralColors.secondaryBGColor,
                      child: Icon(
                        Icons.image_outlined,
                        color: GeneralColors.textGrayColor,
                      ),
                    )
                  : CachedImage(
                      imageUrl: imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          HSpacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GeneralTextStyle.titleText(fontSize: 14),
                ),
                VSpacer.xs(),
                Text(
                  '${formatPrice(item.unitPrice)} × ${item.quantity}',
                  style: GeneralTextStyle.bodyText(
                    textColor: GeneralColors.textGrayColor,
                  ),
                ),
              ],
            ),
          ),
          HSpacer.sm(),
          Text(
            formatPrice(item.lineTotal),
            style: GeneralTextStyle.titleText(fontSize: 14),
          ),
        ],
      ),
    );
  }

}
