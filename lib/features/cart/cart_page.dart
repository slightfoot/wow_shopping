import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/min_lines.dart';
import 'package:wow_shopping/widgets/product_image.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItem>>(
        initialData: cartRepo.currentCartItems,
        stream: cartRepo.streamCartItems,
        builder: (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
          final items = snapshot.requireData;
          return SizedBox.expand(
            child: Material(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: TopNavBar(
                      title: Builder(
                        builder: (BuildContext context) {
                          if (items.isEmpty) {
                            return const Text('No items in your cart');
                          } else {
                            return Text('${items.length} items in your cart');
                          }
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: _DeliveryAddressCta(
                        // FIXME: onChangeAddress ?
                        ),
                  ),
                  for (final item in items) //
                    _SliverCartItemView(
                      key: Key(item.product.id),
                      item: item,
                    ),
                ],
              ),
            ),
          );
        });
  }
}

@immutable
class _DeliveryAddressCta extends StatelessWidget {
  const _DeliveryAddressCta();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding12 + verticalPadding16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Delivery to '),
                      TextSpan(
                        // FIXME: replace with selected address name
                        text: 'Designer Techcronus',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalMargin4,
                // FIXME: replace with selected address
                Text(
                  '4/C Center Point,Panchvati, '
                  'Ellisbridge, Ahmedabad, Gujarat 380006',
                ),
              ],
            ),
          ),
          AppButton(
            onPressed: () {
              // FIXME open Delivery address screen
            },
            style: AppButtonStyle.outlined,
            label: 'Change',
          ),
        ],
      ),
    );
  }
}

@immutable
class _SliverCartItemView extends StatelessWidget {
  const _SliverCartItemView({
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
                          child: CartQuantityWidget(
                            item: item,
                          ),
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

class CartQuantityWidget extends StatefulWidget {
  const CartQuantityWidget({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  State<CartQuantityWidget> createState() => _CartQuantityWidgetState();
}

class _CartQuantityWidgetState extends State<CartQuantityWidget> {
  late TextEditingController _quantityController;
  late FocusNode _quantityFocus;

  int get quantity => int.tryParse(_quantityController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _quantityController.addListener(_onQuantityChanged);
    _quantityFocus = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CartQuantityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.quantity != oldWidget.item.quantity) {
      _quantityController.text = widget.item.quantity.toString();
    }
  }

  void _onQuantityChanged() {
    context.cartRepo.updateQuantity(widget.item.product.id, quantity);
  }

  void _onMinusPressed() {
    final current = quantity;
    if (current == 1) {
      context.cartRepo.removeToCart(widget.item.product.id);
    } else {
      _quantityController.text = (quantity - 1).toString();
    }
  }

  void _onAddPressed() {
    _quantityController.text = (quantity + 1).toString();
  }

  @override
  void dispose() {
    _quantityFocus.dispose();
    _quantityController.removeListener(_onQuantityChanged);
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: appButtonRadius,
        side: BorderSide(
          color: appTheme.appColor,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _onMinusPressed,
              child: Padding(
                padding: leftPadding12 + verticalPadding4 + verticalPadding2,
                child: ValueListenableBuilder(
                  valueListenable: _quantityController,
                  builder: (BuildContext context, TextEditingValue value, Widget? child) {
                    return AppIcon(
                      iconAsset: quantity <= 1 ? Assets.iconRemove : Assets.iconMinus,
                      color: appTheme.appColor,
                    );
                  },
                ),
              ),
            ),
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 48.0),
                child: TextField(
                  focusNode: _quantityFocus,
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: verticalPadding4,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  onTapOutside: (_) {
                    _quantityFocus.unfocus();
                  },
                ),
              ),
            ),
            InkWell(
              onTap: _onAddPressed,
              child: Padding(
                padding: rightPadding12 + verticalPadding4 + verticalPadding2,
                child: AppIcon(
                  iconAsset: Assets.iconAdd,
                  color: appTheme.appColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
