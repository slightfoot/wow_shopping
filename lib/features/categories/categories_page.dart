import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/widgets/category_nav_list.dart';
import 'package:wow_shopping/widgets/common.dart';
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
                  icon: SvgPicture.asset(Assets.iconSearch),
                ),
              ],
              bottom: CategoryNavList(
                selected: _selectedCategory,
                onCategoryItemPressed: _onCategoryItemPressed,
              ),
            ),
            Expanded(
              child: SliverExpansionHost(
                child: CustomScrollView(
                  slivers: [
                    for (final item in [1, 2, 3, 4, 5, 6]) ...[
                      SliverExpansionTileHeader(
                        section: '$item',
                        padding: horizontalPadding24 + verticalPadding16,
                        child: Text('Category $item'),
                      ),
                      SliverExpansionTileContent(
                        section: '$item',
                        sliverBuilder: (BuildContext context) {
                          return SliverPadding(
                            padding: horizontalPadding8,
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 3 / 2),
                              delegate: SliverChildBuilderDelegate(
                                childCount: 6,
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
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class SliverExpansionHost extends StatefulWidget {
  const SliverExpansionHost({
    super.key,
    required this.child,
  });

  final Widget child;

  static SliverExpansionController controllerOf(BuildContext context) {
    return context.findAncestorStateOfType<_SliverExpansionHostState>()!.controller;
  }

  @override
  State<SliverExpansionHost> createState() => _SliverExpansionHostState();
}

class SliverExpansionController extends ChangeNotifier {
  final _expandedSections = <String>[];

  bool isSectionExpanded(String section) => _expandedSections.contains(section);

  void toggleExpanded(String section) {
    if (isSectionExpanded(section)) {
      setExpanded(section, false);
    } else {
      setExpanded(section, true);
    }
  }

  void setExpanded(String section, bool expanded) {
    if (expanded) {
      _expandedSections.add(section);
    } else {
      _expandedSections.remove(section);
    }
    notifyListeners();
  }
}

class _SliverExpansionHostState extends State<SliverExpansionHost> {
  final controller = SliverExpansionController();

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

@immutable
class SliverExpansionTileHeader extends StatefulWidget {
  const SliverExpansionTileHeader({
    super.key,
    required this.section,
    this.padding = emptyPadding,
    required this.child,
  });

  final String section;
  final EdgeInsets padding;
  final Widget child;

  @override
  State<SliverExpansionTileHeader> createState() => _SliverExpansionTileHeaderState();
}

class _SliverExpansionTileHeaderState extends State<SliverExpansionTileHeader> {
  late final controller = SliverExpansionHost.controllerOf(context);
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = controller.isSectionExpanded(widget.section);
    controller.addListener(_onExpandedSectionsChanged);
  }

  void _onExpandedSectionsChanged() {
    setState(() {
      _expanded = controller.isSectionExpanded(widget.section);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_onExpandedSectionsChanged);
    super.dispose();
  }

  void _toggleExpansion() {
    controller.toggleExpanded(widget.section);
  }

  @override
  Widget build(BuildContext context) {
    final rightPadding = EdgeInsets.only(right: widget.padding.right);
    return SliverToBoxAdapter(
      child: IntrinsicHeight(
        child: Material(
          child: InkWell(
            onTap: _toggleExpansion,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: widget.padding.subtract(rightPadding),
                    child: widget.child,
                  ),
                ),
                Padding(
                  padding: rightPadding,
                  child: Icon(
                    _expanded //
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
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
class SliverExpansionTileContent extends StatefulWidget {
  const SliverExpansionTileContent({
    super.key,
    required this.section,
    required this.sliverBuilder,
  });

  final String section;
  final WidgetBuilder sliverBuilder;

  @override
  State<SliverExpansionTileContent> createState() => _SliverExpansionTileContentState();
}

class _SliverExpansionTileContentState extends State<SliverExpansionTileContent> {
  late final controller = SliverExpansionHost.controllerOf(context);

  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = controller.isSectionExpanded(widget.section);
    controller.addListener(_onExpandedSectionsChanged);
  }

  void _onExpandedSectionsChanged() {
    setState(() {
      _expanded = controller.isSectionExpanded(widget.section);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_onExpandedSectionsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_expanded) {
      return widget.sliverBuilder(context);
    } else {
      return emptySliver;
    }
  }
}
