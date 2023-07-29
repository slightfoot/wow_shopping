import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/nav_item.dart';
import 'package:wow_shopping/widgets/common.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
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
    return Material(
      color: appTheme.appBarColor,
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
    final appTheme = AppTheme.of(context);
    return InkWell(
      onTap: () => onPressed(item),
      child: Padding(
        padding: verticalPadding12 + bottomPadding4,
        child: SvgPicture.asset(
          item.navIconAsset,
          colorFilter: (item != selected) //
              ? appTheme.whiteIcon
              : null,
        ),
      ),
    );
  }
}
