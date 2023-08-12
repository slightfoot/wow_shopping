import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/wishlist_repo_.dart';
import 'package:wow_shopping/features/products/models/product_proxy.dart';
import 'package:wow_shopping/shared/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductProxy item;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  void _onTogglePressed(bool value) {
    if (value) {
      di<WishlistRepo>().addToWishlist(widget.item.id);
    } else {
      di<WishlistRepo>().removeToWishlist(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: di<WishlistRepo>().isInWishlist(widget.item),
      stream: di<WishlistRepo>().streamIsInWishlist(widget.item),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final value = snapshot.requireData;
        return IconButton(
          onPressed: () => _onTogglePressed(!value),
          icon: AppIcon(
            iconAsset: value //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            color: value //
                ? AppTheme.of(context).appColor
                : const Color(0xFFD0D0D0),
          ),
        );
      },
    );
  }
}
