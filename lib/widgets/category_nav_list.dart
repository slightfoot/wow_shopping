import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/category_item.dart';
import 'package:wow_shopping/utils/svg.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class CategoryNavList extends StatelessWidget {
  const CategoryNavList({
    super.key,
    this.selected,
    required this.onCategoryItemPressed,
  });

  final CategoryItem? selected;
  final ValueChanged<CategoryItem> onCategoryItemPressed;

  static Future<void> precacheImages() async {
    await Future.wait([
      for (final item in CategoryItem.values) SvgPicture.asset(item.iconAsset).precache(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in CategoryItem.values) //
              _CategoryItemView(
                onPressed: onCategoryItemPressed,
                item: item,
                selected: item == selected,
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _CategoryItemView extends StatelessWidget {
  const _CategoryItemView({
    required this.onPressed,
    required this.item,
    this.selected = false,
  });

  final ValueChanged<CategoryItem> onPressed;
  final CategoryItem item;
  final bool selected;

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
              AppIcon(
                iconAsset: item.iconAsset,
                color: iconTheme.color!,
                highlighted: selected,
              ),
              verticalMargin4,
              Text(
                item.title,
                style: TextStyle(
                  color: selected //
                      ? AppTheme.of(context).appColorLight
                      : Colors.white,
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
