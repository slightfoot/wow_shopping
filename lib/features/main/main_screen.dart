import 'package:flutter/material.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/features/main/widgets/top_nav.dart';
import 'package:wow_shopping/models/category_item.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NavItem _selected = NavItem.home;

  void _onCategoryItemPressed(CategoryItem value) {
    //
  }

  void _onNavItemPressed(NavItem item) {
    setState(() => _selected = item);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          children: [
            TopNavBar(
              onCategoryItemPressed: _onCategoryItemPressed,
              onFilterPressed: () {
                //
              },
              onSearchPressed: () {
                //
              },
            ),
            const Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PromoCarousel(),
                  ),
                ],
              ),
            ),
            BottomNavBar(
              onNavItemPressed: _onNavItemPressed,
              selected: _selected,
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _promos = [
    Assets.promo1,
    Assets.promo2,
    Assets.promo1,
    Assets.promo2,
  ];
  final _controller = PageController(viewportFraction: 0.8);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPromoPressed(String promo) {
    //
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.0 + 170.0 + 12.0,
      child: PageView(
        controller: _controller,
        children: [
          for (final promo in _promos) //
            Padding(
              padding: verticalPadding12 + horizontalPadding8,
              child: _PromoCarouselItem(
                onPressed: () => _onPromoPressed(promo),
                asset: promo,
              ),
            ),
        ],
      ),
    );
  }
}

@immutable
class _PromoCarouselItem extends StatelessWidget {
  const _PromoCarouselItem({
    super.key,
    required this.onPressed,
    required this.asset,
  });

  final VoidCallback onPressed;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(
        Radius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink.image(
          image: AssetImage(asset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
