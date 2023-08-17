import 'package:flutter/material.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/category_nav_list.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/sliver_expansion_tile.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  var _selectedCategory = CategoryItem.global;

  void _onCategoryItemPressed(CategoryItem value) {
    // FIXME: implement filter or deep link?
    setState(() {
      _selectedCategory = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopNavBar(
              title: const Text('Categories'),
              actions: [
                IconButton(
                  onPressed: () {
                    // FIXME: perform search
                  },
                  icon: const AppIcon(iconAsset: Assets.iconSearch),
                ),
              ],
              bottom: CategoryNavList(
                selected: _selectedCategory,
                onCategoryItemPressed: _onCategoryItemPressed,
              ),
            ),
            Expanded(
              child: SliverExpansionTileHost(
                child: ClipRect(
                  child: CustomScrollView(
                    clipBehavior: Clip.hardEdge,
                    slivers: [
                      for (final item in CategoryItem.values) //
                        SliverCategoryGroup(item: item),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverCategoryGroup extends StatelessWidget {
  const SliverCategoryGroup({
    super.key,
    required this.item,
  });

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    return SliverExpansionTile(
      section: item.name,
      headerBuilder: (BuildContext context, String section, bool expanded) {
        return Padding(
          padding: horizontalPadding24 + verticalPadding16,
          child: Row(
            children: [
              AppIcon(iconAsset: item.iconAsset),
              horizontalMargin16,
              Text(item.title),
              horizontalMargin16,
              const Spacer(),
              ExpansionTileChevron(section: item.name),
            ],
          ),
        );
      },
      contentBuilder: (BuildContext context) {
        return SliverPadding(
          padding: horizontalPadding8,
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: 4,
              (BuildContext context, int index) {
                return const Padding(
                  padding: allPadding8,
                  child: Placeholder(color: Colors.black26),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
