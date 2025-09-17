import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/content_heading.dart';
import 'package:wow_shopping/widgets/product_card.dart';

@immutable
class SliverTopSelling extends StatefulWidget {
  const SliverTopSelling({super.key});

  @override
  State<SliverTopSelling> createState() => _SliverTopSellingState();
}

class _SliverTopSellingState extends State<SliverTopSelling> {
  late Future<List<ProductItem>> _futureTopSelling;

  @override
  void initState() {
    super.initState();
    _futureTopSelling = productsRepo.fetchTopSelling();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductItem>>(
      initialData: productsRepo.currentTopSelling(),
      future: _futureTopSelling,
      builder: (BuildContext context, AsyncSnapshot<List<ProductItem>> snapshot) {
        if (snapshot.hasData == false) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final data = snapshot.requireData;
          final childAxisCount = deviceType.isTablet ? 4 : 2;
          return SliverMainAxisGroup(
            slivers: [
              SliverPadding(
                padding: horizontalPadding8,
                sliver: SliverToBoxAdapter(
                  child: ContentHeading(
                    title: 'Top Selling Items',
                    buttonLabel: 'Show All',
                    onButtonPressed: () {
                      // FIXME: show all top selling items
                    },
                  ),
                ),
              ),
              sliverMainAxisVerticalMargin8,
              for (int index = 0; index < data.length; index += childAxisCount) ...[
                SliverCrossAxisGroup(
                  slivers: [
                    sliverCrossAxisHorizontalMargin12,
                    for (int crossIndex = 0; crossIndex < childAxisCount; crossIndex++) ...[
                      SliverCrossAxisExpanded(
                        flex: 1,
                        sliver: Builder(
                          builder: (context) {
                            final itemIndex = index + crossIndex;
                            if (itemIndex >= data.length) {
                              return emptySliver;
                            }
                            final item = data[itemIndex];
                            return SliverProductCard(
                              key: Key('top-selling-${item.id}'),
                              item: item,
                            );
                          },
                        ),
                      ),
                      sliverCrossAxisHorizontalMargin12,
                    ],
                  ],
                ),
                sliverMainAxisVerticalMargin12,
              ],
            ],
          );
        }
      },
    );
  }
}
