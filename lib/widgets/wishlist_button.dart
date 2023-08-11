import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/bloc/wishlist_button_bloc.dart';

@immutable
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WishlistButtonBloc(wishlistRepo: context.wishlistRepo, item: item)
            ..add(WishlistStarted()),
      child: const WishlistButtonContent(),
    );
  }

  // void _onTogglePressed(bool value) {
  //   if (value) {
  //     wishlistRepo.addToWishlist(widget.item.id);
  //   } else {
  //     wishlistRepo.removeToWishlist(widget.item.id);
  //   }
  // }
}

class WishlistButtonContent extends StatelessWidget {
  const WishlistButtonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistButtonBloc, WishlistButtonState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => context
              .read<WishlistButtonBloc>()
              .add(IsTogglePressed(isItemWishlisted: !state.isWishlisted)),
          icon: AppIcon(
            iconAsset: state.isWishlisted //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            color: state.isWishlisted //
                ? AppTheme.of(context).appColor
                : const Color(0xFFD0D0D0),
          ),
        );
      },
    );
  }
}
