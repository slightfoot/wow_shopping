import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

@immutable
class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  late final wishlistRepo = context.backend.wishlistRepo;

  void _onTogglePressed(bool value) {
    if (value) {
      wishlistRepo.addToWishlist(widget.item);
    } else {
      wishlistRepo.removeToWishlist(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: wishlistRepo.isInWishlist(widget.item),
      stream: wishlistRepo.streamIsInWishlist(widget.item),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final value = snapshot.requireData;
        return IconButton(
          onPressed: () => _onTogglePressed(!value),
          icon: SvgPicture.asset(
            value //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            colorFilter: ColorFilter.mode(
              value ? AppTheme.of(context).appColor : const Color(0xFFD0D0D0),
              BlendMode.srcIn,
            ),
          ),
        );
      },
    );
  }
}
