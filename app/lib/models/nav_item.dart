import 'package:flutter/material.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/features/account/account_page.dart';
import 'package:wow_shopping/features/cart/cart_page.dart';
import 'package:wow_shopping/features/categories/categories_page.dart';
import 'package:wow_shopping/features/home/home_page.dart';
import 'package:wow_shopping/features/wishlist/wishlist_page.dart';

enum NavItem {
  home(Assets.navHome, 'Home', HomePage.new),
  categories(Assets.navCategories, 'Categories', CategoriesPage.new),
  cart(Assets.navCart, 'Cart', CartPage.new),
  wishlist(Assets.navWishlist, 'Wishlist', WishlistPage.new),
  account(Assets.navAccount, 'Account', AccountPage.new);

  const NavItem(this.navIconAsset, this.navTitle, this.builder);

  final String navIconAsset;
  final String navTitle;
  final Widget Function() builder;
}
