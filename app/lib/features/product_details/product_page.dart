import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/content_heading.dart';
import 'package:wow_shopping/widgets/product_card.dart';
import 'package:wow_shopping/widgets/product_image.dart';
import 'package:wow_shopping/widgets/sliver_expansion_tile.dart';
import 'package:wow_shopping/widgets/wishlist_button.dart';
import 'package:wow_shopping/backend/backend.dart';

@immutable
class ProductPage extends StatelessWidget {
  const ProductPage._({
    required this.item,
  });

  final ProductItem item;

  static Route<void> route(ProductItem item) {
    return PageRouteBuilder(
      settings: RouteSettings(name: '/products/${item.id}'),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0.66, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.easeInCubic,
            ),
            child: ProductPage._(item: item),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SliverExpansionTileHost(
        initialExpanded: const ['description'],
        child: CustomScrollView(
          slivers: [
            _SliverProductHeader(item: item),
            _SliverProductTitle(item: item),
            _SliverProductPhotoGallery(
              initialImageIndex: 0,
              item: item,
            ),
            _SliverProductSizeSelector(item: item),
            const _SliverProductInfoTileHeader(
              section: 'description',
              title: 'Description',
            ),
            _SliverProductInfoTileContent(
              section: 'description',
              child: Text(item.description),
            ),
            const _SliverDivider(),
            //
            const _SliverProductInfoTileHeader(
              section: 'specification',
              title: 'Specification',
            ),
            _SliverProductInfoTileContent(
              section: 'specification',
              child: Text('\u2022 Spec Item\n' * 20),
            ),
            const _SliverDivider(),
            //
            const _SliverProductInfoTileHeader(
              section: 'review',
              title: 'Review',
            ),
            const _SliverProductInfoTileContent(
              section: 'review',
              child: Text('Review Info'),
            ),
            const _SliverDivider(),
            //
            const _SliverProductInfoTileHeader(
              section: 'shipping',
              title: 'Shipping & Delivery',
            ),
            const _SliverProductInfoTileContent(
              section: 'shipping',
              child: Text('Shipping Info'),
            ),
            const _SliverDivider(),
            //
            _SliverSimilarItems(
              similarItems: context.productsRepo.cachedItems,
            ),
            //
            const SliverSafeArea(
              top: false,
              sliver: emptySliver,
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _SliverProductHeader extends StatelessWidget {
  const _SliverProductHeader({
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      delegate: _AppBarDelegate(
        item: item,
        padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
        onShare: () {
          // FIXME: share product
        },
      ),
    );
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  _AppBarDelegate({
    required this.item,
    required this.padding,
    this.onShare,
  });

  final ProductItem item;
  final EdgeInsets padding;
  final VoidCallback? onShare;

  @override
  double get minExtent => padding.top + kToolbarHeight;

  @override
  double get maxExtent => padding.top + kToolbarHeight;

  @override
  bool shouldRebuild(covariant _AppBarDelegate oldDelegate) => false;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: Ink(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: appDividerColor, width: 1.0),
          ),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              const BackButton(),
              Expanded(
                child: Text(
                  item.subTitle,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onShare != null)
                IconButton(
                  onPressed: onShare,
                  icon: const Icon(Icons.share),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _SliverProductTitle extends StatelessWidget {
  const _SliverProductTitle({
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: verticalPadding4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: horizontalPadding24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  horizontalMargin16,
                  Text(
                    item.formattedPriceWithTax,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // FIXME: open ratings
                    },
                    child: Padding(
                      padding: verticalPadding4 + leftPadding24,
                      child: _SmallProductRating(
                        item: item,
                      ),
                    ),
                  ),
                ),
                horizontalMargin8,
                const Text(
                  '(inclusive of all taxes)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                horizontalMargin24,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _SmallProductRating extends StatelessWidget {
  const _SmallProductRating({
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: 14.0,
          color: AppTheme.of(context).appColor,
        ),
        Text(
          '3.4', // FIXME: get average rating value
          style: TextStyle(
            color: AppTheme.of(context).appColor,
          ),
        ),
        const Text(
          '(27)', // FIXME: get number of ratings
          style: TextStyle(
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}

@immutable
class _SliverProductPhotoGallery extends StatefulWidget {
  const _SliverProductPhotoGallery({
    required this.initialImageIndex,
    required this.item,
  });

  final int initialImageIndex;
  final ProductItem item;

  @override
  State<_SliverProductPhotoGallery> createState() => _SliverProductPhotoGalleryState();
}

class _SliverProductPhotoGalleryState extends State<_SliverProductPhotoGallery> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialImageIndex;
  }

  void _onPhotoPressed(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: horizontalPadding24,
            child: AspectRatio(
              aspectRatio: 5 / 4,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: appButtonRadius,
                      child: ProductImage(
                        imageIndex: _selectedIndex,
                        inkEnabled: false,
                        item: widget.item,
                      ),
                    ),
                  ),
                  WishlistButton(item: widget.item),
                ],
              ),
            ),
          ),
          verticalMargin16,
          SizedBox(
            height: 74.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: leftPadding24 + rightPadding8,
              itemCount: widget.item.photos.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: rightPadding16,
                  child: _PhotoGalleryItem(
                    onPhotoPressed: () => _onPhotoPressed(index),
                    item: widget.item,
                    index: index,
                    selected: _selectedIndex == index,
                  ),
                );
              },
            ),
          ),
          verticalMargin16,
        ],
      ),
    );
  }
}

@immutable
class _PhotoGalleryItem extends StatelessWidget {
  const _PhotoGalleryItem({
    required this.onPhotoPressed,
    required this.index,
    required this.item,
    required this.selected,
  });

  final VoidCallback onPhotoPressed;
  final int index;
  final ProductItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: InkWell(
        onTap: onPhotoPressed,
        customBorder: const RoundedRectangleBorder(
          borderRadius: appButtonRadius,
        ),
        child: ProductImage(
          imageIndex: index,
          item: item,
        ),
      ),
    );
  }
}

@immutable
class _SliverProductSizeSelector extends StatelessWidget {
  const _SliverProductSizeSelector({
    required this.item,
  });

  final ProductItem item;

  static const _sizes = [6, 7, 8, 9, 10, 11, 12, 13];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: appLightGreyColor,
          border: Border(
            top: BorderSide(color: appDividerColor, width: 1.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: horizontalPadding8,
              child: ContentHeading(
                title: 'Select Size',
                buttonLabel: 'Size chart',
                onButtonPressed: () {
                  // FIXME: show size chart
                },
              ),
            ),
            SizedBox(
              height: 80.0,
              child: ListView.builder(
                padding: topPadding8 + bottomPadding24 + horizontalPadding16,
                scrollDirection: Axis.horizontal,
                itemCount: _sizes.length,
                itemBuilder: (BuildContext context, int index) {
                  final size = _sizes[index];
                  return Padding(
                    padding: rightPadding8,
                    child: Center(
                      child: Material(
                        borderRadius: appButtonRadius,
                        elevation: 1.0,
                        child: InkWell(
                          onTap: () {
                            // FIXME: Select size
                          },
                          customBorder: const RoundedRectangleBorder(
                            borderRadius: appButtonRadius,
                          ),
                          child: Padding(
                            padding: verticalPadding8 + horizontalPadding16,
                            child: Text(
                              'UK $size',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: horizontalPadding16,
              child: AppButton(
                onPressed: () {
                  // FIXME: add product to cart
                  // FIXME: specify option for size
                  context.cartRepo.addToCart(item);
                },
                label: 'Add to cart',
                style: AppButtonStyle.highlighted,
              ),
            ),
            verticalMargin16,
          ],
        ),
      ),
    );
  }
}

@immutable
class _SliverProductInfoTileHeader extends StatelessWidget {
  const _SliverProductInfoTileHeader({
    required this.section,
    required this.title,
  });

  final String section;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverExpansionTileHeader(
      section: section,
      builder: (BuildContext context, String section, bool expanded) {
        return Padding(
          padding: horizontalPadding24 + verticalPadding16,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ExpansionTileChevron(section: section),
            ],
          ),
        );
      },
    );
  }
}

@immutable
class _SliverProductInfoTileContent extends StatelessWidget {
  const _SliverProductInfoTileContent({
    required this.section,
    required this.child,
  });

  final String section;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverExpansionTileContent(
      section: section,
      sliverBuilder: (BuildContext context) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: horizontalPadding24 + bottomPadding24,
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

@immutable
class _SliverDivider extends StatelessWidget {
  const _SliverDivider();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 1.0,
        child: ColoredBox(color: appDividerColor),
      ),
    );
  }
}

@immutable
class _SliverSimilarItems extends StatelessWidget {
  const _SliverSimilarItems({
    required this.similarItems,
  });

  final List<ProductItem> similarItems;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: horizontalPadding8,
            child: ContentHeading(
              title: 'Similar Items/Products',
              buttonLabel: 'Show All',
              onButtonPressed: () {
                // FIXME: show all similar items in new route
              },
            ),
          ),
          SizedBox(
            height: 280.0,
            child: ListView.builder(
              padding: topPadding8 + bottomPadding24 + horizontalPadding16,
              scrollDirection: Axis.horizontal,
              itemCount: similarItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = similarItems[index];
                return Padding(
                  padding: rightPadding8,
                  child: AspectRatio(
                    aspectRatio: 2 / 4,
                    child: ProductCard(
                      item: item,
                    ),
                  ),
                );
              },
            ),
          ),
          verticalMargin24,
        ],
      ),
    );
  }
}
