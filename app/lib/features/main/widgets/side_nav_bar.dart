import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
import 'package:wow_shopping/widgets/common.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({
    super.key,
    required this.onNavItemPressed,
    required this.selected,
  });

  final ValueChanged<NavItem> onNavItemPressed;
  final NavItem selected;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return AnnotatedRegion(
      value: appOverlayLightIcons,
      child: IconTheme.merge(
        data: const IconThemeData(
          color: Colors.white,
        ),
        child: SizedBox(
          width: 120.0,
          child: Material(
            color: appTheme.appBarColor,
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: viewPadding.top,
                  bottom: viewPadding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: horizontalPadding8 + verticalPadding16,
                      child: SvgPicture.asset(Assets.logo),
                    ),
                    for (final item in NavItem.values) //
                      BottomNavButton(
                        onPressed: onNavItemPressed,
                        item: item,
                        selected: selected,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
