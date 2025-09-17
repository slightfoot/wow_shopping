import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/home/widgets/promo_carousel.dart';
import 'package:wow_shopping/features/home/widgets/sliver_featured_categories.dart';
import 'package:wow_shopping/features/home/widgets/sliver_top_selling.dart';
import 'package:wow_shopping/features/main/main_navigation.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/utils/svg.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/category_nav_list.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Future<void> precacheImages() async {
    await Future.wait([
      SvgPicture.asset(Assets.logo).precache(),
      SvgPicture.asset(Assets.iconFilter).precache(),
      SvgPicture.asset(Assets.iconSearch).precache(),
      CategoryNavList.precacheImages(),
    ]);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onCategoryItemPressed(CategoryItem value) {
    // FIXME: implement filter or deep link?
  }

  void _onPromoPressed(PromoModel promo) {
    // FIXME: demo of gotoSection
    if (promo.asset == Assets.promo1) {
      context.mainNav.gotoSection(NavItem.wishlist);
    } else if (promo.asset == Assets.promo2) {
      context.mainNav.gotoSection(NavItem.cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          children: [
            DeviceTypeBuilder(
              builder:
                  (
                    BuildContext context,
                    DeviceTypeOrientationState state,
                    Widget? child,
                  ) {
                    if (state.isTablet && state.isLandscape) {
                      return emptyWidget;
                    }
                    return TopNavBar(
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
                    );
                  },
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
                  sliverMainAxisVerticalMargin24,
                  const SliverFeaturedCategories(),
                  sliverMainAxisVerticalMargin48,
                  sliverMainAxisVerticalMargin48,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
