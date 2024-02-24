import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/widgets/category_card.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/content_heading.dart';

class SliverFeaturedCategories extends StatelessWidget {
  const SliverFeaturedCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        DecoratedSliver(
          decoration: const ShapeDecoration(
            color: appLightGreyColor,
            shape: Border(
              top: BorderSide(color: appDividerColor, width: 2.0),
            ),
          ),
          sliver: SliverPadding(
            padding: verticalPadding24,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: horizontalPadding8,
                    child: ContentHeading(title: 'Featured Categories'),
                  ),
                  verticalMargin16,
                  AspectRatio(
                    aspectRatio: context.deviceType.isTablet ? 5.5 : 3.5,
                    child: ListView.builder(
                      padding: horizontalPadding16,
                      scrollDirection: Axis.horizontal,
                      itemCount: context.categoryRepo.featuredCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AspectRatio(
                          aspectRatio: 1.0,
                          child: Padding(
                            padding: rightPadding4 + rightPadding2 + bottomPadding8,
                            child: CategoryCard(
                              category: context.categoryRepo.featuredCategories[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
