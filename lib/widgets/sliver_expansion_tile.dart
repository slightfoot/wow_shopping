import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/widgets/common.dart';

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

@immutable
class SliverExpansionTileHost extends StatefulWidget {
  const SliverExpansionTileHost({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SliverExpansionTileHost> createState() => _SliverExpansionTileHostState();
}

class _SliverExpansionTileHostState extends State<SliverExpansionTileHost> {
  final controller = SliverExpansionController();

  @override
  Widget build(BuildContext context) {
    return _InheritedSliverExpansionTile(
      controller: controller,
      child: widget.child,
    );
  }
}

@immutable
class _InheritedSliverExpansionTile extends InheritedNotifier<SliverExpansionController> {
  const _InheritedSliverExpansionTile({
    Key? key,
    required controller,
    required Widget child,
  }) : super(key: key, notifier: controller, child: child);

  static SliverExpansionController of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_InheritedSliverExpansionTile>()!.notifier!;
    } else {
      return context.getInheritedWidgetOfExactType<_InheritedSliverExpansionTile>()!.notifier!;
    }
  }
}

@immutable
class SliverExpansionTileHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final controller = _InheritedSliverExpansionTile.of(context);
    final expanded = controller.isSectionExpanded(section);
    final rightPadding = EdgeInsets.only(right: padding.right);
    return SliverToBoxAdapter(
      child: IntrinsicHeight(
        child: Material(
          child: InkWell(
            onTap: () => controller.toggleExpanded(section),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: padding.subtract(rightPadding),
                    child: child,
                  ),
                ),
                Padding(
                  padding: rightPadding,
                  child: AppIcon(
                    iconAsset: expanded //
                        ? Assets.iconChevronUp
                        : Assets.iconChevronDown,
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
class SliverExpansionTileContent extends StatelessWidget {
  const SliverExpansionTileContent({
    super.key,
    required this.section,
    required this.sliverBuilder,
  });

  final String section;
  final WidgetBuilder sliverBuilder;

  @override
  Widget build(BuildContext context) {
    final controller = _InheritedSliverExpansionTile.of(context);
    if (controller.isSectionExpanded(section)) {
      return sliverBuilder(context);
    } else {
      return emptySliver;
    }
  }
}
