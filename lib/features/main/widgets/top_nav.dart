import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/category_item.dart';
import 'package:wow_shopping/widgets/common.dart';

export 'package:wow_shopping/models/category_item.dart';

@immutable
class TopNavBar extends StatelessWidget {
  const TopNavBar({
    super.key,
    this.onFilterPressed,
    this.onSearchPressed,
    required this.onCategoryItemPressed,
  });

  final VoidCallback? onFilterPressed;
  final VoidCallback? onSearchPressed;
  final ValueChanged<CategoryItem> onCategoryItemPressed;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return AnnotatedRegion(
      value: appOverlayLightIcons,
      child: Material(
        color: appTheme.appBarColor,
        child: IconTheme.merge(
          data: const IconThemeData(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: viewPadding.top),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 8.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onFilterPressed != null) //
                            IconButton(
                              onPressed: onFilterPressed,
                              visualDensity: VisualDensity.compact,
                              icon: SvgPicture.asset(Assets.iconFilter),
                            ),
                          if (onSearchPressed != null) //
                            IconButton(
                              onPressed: onSearchPressed,
                              visualDensity: VisualDensity.compact,
                              icon: SvgPicture.asset(Assets.iconSearch),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: verticalPadding8,
                      child: SvgPicture.asset(
                        Assets.logo,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final item in CategoryItem.values) //
                          TopBarCategoryItem(
                            onPressed: onCategoryItemPressed,
                            item: item,
                          ),
                      ],
                    ),
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
class TopBarCategoryItem extends StatelessWidget {
  const TopBarCategoryItem({
    super.key,
    required this.onPressed,
    required this.item,
  });

  final ValueChanged<CategoryItem> onPressed;
  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 78.0,
      ),
      child: InkWell(
        onTap: () => onPressed(item),
        child: Padding(
          padding: allPadding8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                item.iconAsset,
                colorFilter: ColorFilter.mode(iconTheme.color!, BlendMode.srcIn),
              ),
              verticalMargin4,
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
