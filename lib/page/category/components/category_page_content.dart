import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/shared/cached_image.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/home/model/category_response.dart';

class CategoryPageContent extends StatelessWidget {
  const CategoryPageContent({super.key, required this.categories});

  final List<CategoryResponse> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return RefreshableStateView(
        child: EmptyStateView(
          icon: Icons.category_outlined,
          title: 'Ангилал олдсонгүй',
          message: 'Одоогоор харуулах ангилал алга байна.',
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ангилал', style: GeneralTextStyle.titleText(fontSize: 26)),
            VSpacer.xs(),
            Text(
              'Хайж буй бараагаа ангиллаар олоорой.',
              style: GeneralTextStyle.bodyText(
                textColor: GeneralColors.textGrayColor,
              ),
            ),
            VSpacer.lg(),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) => _CategoryCard(
                category: categories[index],
                onTap: () => context.push(
                  '/search?category_id=${categories[index].id}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final CategoryResponse category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: GeneralColors.primaryBGColor,
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
                child: SizedBox(
                  width: double.infinity,
                  child: category.image?.preview != null
                      ? CachedImage(
                          imageUrl: category.image!.preview!,
                          fit: BoxFit.cover,
                          borderRadius: 12,
                        )
                      : category.image?.url != null
                      ? CachedImage(
                          imageUrl: category.image!.url!,
                          fit: BoxFit.cover,
                          borderRadius: 12,
                        )
                      : category.image?.thumbnail != null
                      ? CachedImage(
                          imageUrl: category.image!.thumbnail!,
                          fit: BoxFit.cover,
                          borderRadius: 12,
                        )
                      : const ColoredBox(
                          color: GeneralColors.secondaryBGColor,
                          child: Icon(
                            Icons.category_outlined,
                            size: 36,
                            color: GeneralColors.primaryColor,
                          ),
                        ),
                ),
              ),
            ),
            VSpacer.sm(),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GeneralTextStyle.titleText(fontSize: 15),
            ),
            if (category.productsCount != null) ...[
              VSpacer.xs(),
              Text(
                '${category.productsCount} бараа',
                style: GeneralTextStyle.bodyText(
                  fontSize: 12,
                  textColor: GeneralColors.textGrayColor,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
