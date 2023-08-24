import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/cart/widgets/cart_quantity_selector.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/product_image.dart';

@immutable
class SliverCartItemView extends StatelessWidget {
  const SliverCartItemView({
    required super.key,
    required this.item,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: appDividerColor, width: 1.5),
        ),
      ),
      sliver: SliverPadding(
        padding: bottomPadding12 + horizontalPadding12,
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              verticalMargin12,
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ProductImage(
                      inkEnabled: false,
                      item: item.product,
                    ),
                  ),
                  horizontalMargin16,
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          item.product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        verticalMargin4,
                        Text('Deliver by ${formatShortDate(item.deliveryDate)}'),
                        verticalMargin12,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CartQuantitySelector(item: item),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalMargin8,
              const SizedBox(
                height: 1.0,
                child: ColoredBox(
                  color: appDividerColor,
                ),
              ),
              verticalMargin8,
              DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 2.25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('MRP'),
                        Text(formatCurrency(item.product.price)),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount'),
                        Text('-'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shipping Fee'),
                        Text(formatCurrency(item.deliveryFee)),
                      ],
                    ),
                    const SizedBox(
                      height: 1.0,
                      child: ColoredBox(
                        color: appDividerColor,
                      ),
                    ),
                    DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Selling Price'),
                          Text(formatCurrency(item.total)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
