import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/common.dart';

class CartQuantitySelector extends StatefulWidget {
  const CartQuantitySelector({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  State<CartQuantitySelector> createState() => _CartQuantitySelectorState();
}

class _CartQuantitySelectorState extends State<CartQuantitySelector> {
  late TextEditingController _quantityController;
  late FocusNode _quantityFocus;

  int get quantity => int.tryParse(_quantityController.text.trim()) ?? 0;

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
  void didUpdateWidget(covariant CartQuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.quantity != oldWidget.item.quantity) {
      _updateQuantity(widget.item.quantity);
    }
  }

  void _onQuantityChanged() {
    if (_quantityController.text.trim().isNotEmpty) {
      context.cartRepo.updateQuantity(widget.item.product.id, quantity);
    }
  }

  void _onMinusPressed() {
    final current = quantity;
    if (current == 1) {
      context.cartRepo.removeToCart(widget.item.product.id);
    } else {
      _updateQuantity(quantity - 1);
    }
  }

  void _onAddPressed() {
    _updateQuantity(quantity + 1);
  }

  void _updateQuantity(int value) {
    final text = value.toString();
    _quantityController.value = _quantityController.value.copyWith(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
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
    return TextFieldTapRegion(
      child: Material(
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
                  padding: leftPadding12 + rightPadding8 + verticalPadding4 + verticalPadding2,
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
                  padding: leftPadding8 + rightPadding12 + verticalPadding4 + verticalPadding2,
                  child: AppIcon(
                    iconAsset: Assets.iconAdd,
                    color: appTheme.appColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
