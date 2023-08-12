import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/products/models/product_proxy.dart';
import 'package:wow_shopping/shared/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatelessWidget with WatchItMixin {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductProxy item;

  @override
  Widget build(BuildContext context) {
    final onWishList = watch(item).onWishList;
    return IconButton(
      onPressed: item.toggleWishListCommand,
      icon: AppIcon(
        iconAsset: onWishList //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: onWishList //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
  }
}
