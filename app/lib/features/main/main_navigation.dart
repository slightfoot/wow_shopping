import 'package:flutter/widgets.dart';
import 'package:wow_shopping/models/nav_item.dart';
import 'package:wow_shopping/models/product_item.dart';

abstract interface class MainNavigation {
  void gotoSection(NavItem item);

  Future<void> openProduct(ProductItem item);

  void goBack();

  static MainNavigation _of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<MainNavHost>()!.mainNavigation;
  }
}

extension BuildContextMainNavigationExtension on BuildContext {
  MainNavigation get mainNav => MainNavigation._of(this);
}

class MainNavHost extends StatelessWidget {
  const MainNavHost({
    super.key,
    required this.mainNavigation,
    required this.child,
  });

  final MainNavigation mainNavigation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
