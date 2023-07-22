import 'package:wow_shopping/app/assets.dart';

enum NavItem {
  home(Assets.navHome),
  categories(Assets.navCategories),
  cart(Assets.navCart),
  wishlist(Assets.navWishlist),
  account(Assets.navAccount),
  ;

  const NavItem(this.navIconAsset);

  final String navIconAsset;
}
