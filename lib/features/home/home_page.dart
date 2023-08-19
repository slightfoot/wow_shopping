import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/features/home/widgets/promo_carousel.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/category_nav_list.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/content_heading.dart';
import 'package:wow_shopping/widgets/product_card.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

import '../main/providers/bottom_navbar_provider.dart';

@immutable
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _onCategoryItemPressed(CategoryItem value) {
    // FIXME: implement filter or deep link?
  }

  void _onPromoPressed(PromoModel promo) {
    // FIXME: demo of gotoSection
    if (promo.asset == Assets.promo1) {
      ref.read(bottomNavbarProvider.notifier).gotoSection(NavItem.wishlist);
    } else if (promo.asset == Assets.promo2) {
     ref.read(bottomNavbarProvider.notifier).gotoSection(NavItem.cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          children: [
            TopNavBar(
              title: Padding(
                padding: verticalPadding8,
                child: SvgPicture.asset(Assets.logo),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // FIXME: implement filter
                  },
                  icon: const AppIcon(iconAsset: Assets.iconFilter),
                ),
                IconButton(
                  onPressed: () {
                    // FIXME: implement search
                  },
                  icon: const AppIcon(iconAsset: Assets.iconSearch),
                ),
              ],
              bottom: CategoryNavList(
                onCategoryItemPressed: _onCategoryItemPressed,
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PromoCarousel(
                      promos: const [
                        PromoModel(asset: Assets.promo1),
                        PromoModel(asset: Assets.promo2),
                        PromoModel(asset: Assets.promo1),
                        PromoModel(asset: Assets.promo2),
                      ],
                      onPromoPressed: _onPromoPressed,
                    ),
                  ),
                  const SliverTopSelling(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class SliverTopSelling extends ConsumerStatefulWidget {
  const SliverTopSelling({super.key});

  @override
  ConsumerState<SliverTopSelling> createState() => _SliverTopSellingState();
}

class _SliverTopSellingState extends ConsumerState<SliverTopSelling> {
  late Future<List<ProductItem>> _futureTopSelling;

  @override
  void initState() {
    super.initState();
    
    _futureTopSelling = ref.read(productsRepoProvider).fetchTopSelling();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductItem>>(
      future: _futureTopSelling,
      builder: (BuildContext context, AsyncSnapshot<List<ProductItem>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final data = snapshot.requireData;
          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: horizontalPadding8,
                  child: ContentHeading(
                    title: 'Top Selling Items',
                    buttonLabel: 'Show All',
                    onButtonPressed: () {
                      // FIXME: show all top selling items
                    },
                  ),
                ),
                verticalMargin8,
                for (int index = 0; index < data.length; index += 2) ...[
                  Builder(
                    builder: (BuildContext context) {
                      final item1 = data[index + 0];
                      if (index + 1 < data.length) {
                        final item2 = data[index + 1];
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              horizontalMargin12,
                              Expanded(
                                child: ProductCard(
                                  key: Key('top-selling-${item1.id}'),
                                  item: item1,
                                ),
                              ),
                              horizontalMargin12,
                              Expanded(
                                child: ProductCard(
                                  key: Key('top-selling-${item2.id}'),
                                  item: item2,
                                ),
                              ),
                              horizontalMargin12,
                            ],
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            horizontalMargin12,
                            Expanded(
                              child: ProductCard(
                                key: Key('top-selling-${item1.id}'),
                                item: item1,
                              ),
                            ),
                            horizontalMargin12,
                            const Spacer(),
                            horizontalMargin12,
                          ],
                        );
                      }
                    },
                  ),
                  verticalMargin12,
                ],
                verticalMargin48 + verticalMargin48,
              ],
            ),
          );
        }
      },
    );
  }
}
