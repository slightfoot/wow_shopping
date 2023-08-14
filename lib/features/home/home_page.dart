import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/features/home/top_selling/top_selling.dart';
import 'package:wow_shopping/features/home/widgets/promo_carousel.dart';
import 'package:wow_shopping/features/main/cubit/main_cubit.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/category_nav_list.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class HomePage extends StatelessWidget {
  void _onCategoryItemPressed(CategoryItem value) {
    // FIXME: implement filter or deep link?
  }

  void _onPromoPressed(BuildContext context, {required PromoModel promo}) {
    // FIXME: demo of gotoSection
    if (promo.asset == Assets.promo1) {
      context.read<MainCubit>().gotoSection(NavItem.wishlist);
    } else if (promo.asset == Assets.promo2) {
      context.read<MainCubit>().gotoSection(NavItem.cart);
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
                      onPromoPressed: (promo) => _onPromoPressed(
                        context,
                        promo: promo,
                      ),
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
