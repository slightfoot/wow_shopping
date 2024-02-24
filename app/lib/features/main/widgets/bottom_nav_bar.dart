import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/main/widgets/cart_popup_notification.dart';
import 'package:wow_shopping/models/nav_item.dart';
import 'package:wow_shopping/utils/svg.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/child_builder.dart';
import 'package:wow_shopping/widgets/common.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.onNavItemPressed,
    required this.selected,
  });

  static Future<void> precacheImages() async {
    await Future.wait(NavItem.values.map(
      (el) => SvgPicture.asset(el.navIconAsset).precache(),
    ));
  }

  final ValueChanged<NavItem> onNavItemPressed;
  final NavItem selected;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return Material(
      color: appTheme.appBarColor,
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: viewPadding.bottom),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in NavItem.values) //
                  Expanded(
                    child: BottomNavButton(
                      onPressed: onNavItemPressed,
                      item: item,
                      selected: selected,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    super.key,
    required this.onPressed,
    required this.item,
    required this.selected,
  });

  final ValueChanged<NavItem> onPressed;
  final NavItem item;
  final NavItem selected;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.deviceType.isTablet;
    return ChildBuilder(
      builder: (BuildContext context, Widget child) {
        if (item == NavItem.cart) {
          return CompositedTransformTarget(
            link: CartPopupCountHost.layerLinkOf(context),
            child: child,
          );
        }
        return child;
      },
      child: InkWell(
        onTap: () => onPressed(item),
        child: Padding(
          padding: verticalPadding12 + bottomPadding4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isTablet) //
                verticalMargin8,
              AppIcon(
                iconAsset: item.navIconAsset,
                highlighted: (item == selected),
              ),
              if (isTablet) ...[
                verticalMargin8,
                Text(item.navTitle),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
