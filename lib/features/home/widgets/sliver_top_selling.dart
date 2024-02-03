
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
              for (int index = 0; index < data.length; index += 2) ...[
                Builder(
                  builder: (BuildContext context) {
                    final item1 = data[index + 0];
                    if (index + 1 < data.length) {
                      final item2 = data[index + 1];
                      return SliverCrossAxisGroup(
                        slivers: [
                          sliverCrossAxisHorizontalMargin12,
                          SliverCrossAxisExpanded(
                            flex: 2,
                            sliver: SliverProductCard(
                              key: Key('top-selling-${item1.id}'),
                              item: item1,
                            ),
                          ),
                          sliverCrossAxisHorizontalMargin12,
                          SliverCrossAxisExpanded(
                            flex: 2,
                            sliver: SliverProductCard(
                              key: Key('top-selling-${item2.id}'),
                              item: item2,
                            ),
                          ),
                          sliverCrossAxisHorizontalMargin12,
                        ],
                      );
                    } else {
                      return SliverCrossAxisGroup(
                        slivers: [
                          sliverCrossAxisHorizontalMargin12,
                          SliverCrossAxisExpanded(
                            flex: 1,
                            sliver: SliverProductCard(
                              key: Key('top-selling-${item1.id}'),
                              item: item1,
                            ),
                          ),
                          sliverCrossAxisHorizontalMargin12,
                          const SliverCrossAxisExpanded(
                            flex: 1,
                            sliver: emptySliver,
                          ),
                          sliverCrossAxisHorizontalMargin12,
                        ],
                      );
                    }
                  },
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
