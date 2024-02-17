import 'package:flutter/material.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/features/account/account_page.dart';
import 'package:wow_shopping/features/cart/cart_page.dart';
import 'package:wow_shopping/features/categories/categories_page.dart';
import 'package:wow_shopping/features/home/home_page.dart';
import 'package:wow_shopping/features/wishlist/wishlist_page.dart';

enum NavItem {
  home(Assets.navHome, HomePage.new),
  categories(Assets.navCategories, CategoriesPage.new),
  cart(Assets.navCart, CartPage.new),
  wishlist(Assets.navWishlist, WishlistPage.new),
  account(Assets.navAccount, AccountPage.new),
  ;

  const NavItem(this.navIconAsset, this.builder);

  final String navIconAsset;
  final Widget Function() builder;
}
