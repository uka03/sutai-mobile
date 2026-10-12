import 'package:flutter/material.dart';
import 'package:sutai/core/navigation/product_navigation.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/home/components/product_card.dart';
import 'package:sutai/page/home/model/product_response.dart';

class RelatedProductSection extends StatelessWidget {
  const RelatedProductSection({super.key, required this.products});

  final List<ProductResponse> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Төстэй бараа', style: GeneralTextStyle.titleText(fontSize: 18)),
        VSpacer.sm(),
        SizedBox(
          height: 235,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => HSpacer.sm(),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                width: 158,
                onTap: () => openProduct(context, product),
              );
            },
          ),
        ),
      ],
    );
  }
}
