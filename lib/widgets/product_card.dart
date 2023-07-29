import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/wishlist_button.dart';

@immutable
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.item,
    required this.onPressed,
  });

  final ProductItem item;
  final ValueChanged<ProductItem> onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      borderRadius: appButtonRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onPressed(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned.fill(
                    child: Ink.image(
                      image: AssetImage(item.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  WishlistButton(item: item),
                ],
              ),
            ),
            verticalMargin4,
            Padding(
              padding: horizontalPadding4,
              child: Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: horizontalPadding4,
              child: Text(
                item.subTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppTheme.of(context).appColorLight,
                ),
              ),
            ),
            Padding(
              padding: allPadding4,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatCurrency(item.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      formatCurrency(item.priceWithTax),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
