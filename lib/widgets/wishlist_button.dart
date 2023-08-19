import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends ConsumerStatefulWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  ConsumerState<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends ConsumerState<WishlistButton> {
  void _onTogglePressed(bool value) {
    if (value) {
      ref.read(wishlistRepoProvider).addToWishlist(widget.item.id);
    } else {
      ref.read(wishlistRepoProvider).removeToWishlist(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value =
        ref.watch(wishlistStoreageProvider).items.contains(widget.item.id);
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
  }
}
