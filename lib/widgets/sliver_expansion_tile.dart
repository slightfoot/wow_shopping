import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/common.dart';

class SliverExpansionTileController extends ChangeNotifier {
  SliverExpansionTileController(List<String>? expandedSections) {
    if (expandedSections != null) {
      _expandedSections.addAll(expandedSections);
    }
  }

  final _expandedSections = <String>[];

  bool isExpanded(String section) => _expandedSections.contains(section);

  void toggleExpanded(String section) {
    if (isExpanded(section)) {
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
    this.initialExpanded,
    required this.child,
  });

  final List<String>? initialExpanded;
  final Widget child;

  @override
  State<SliverExpansionTileHost> createState() => _SliverExpansionTileHostState();
}

class _SliverExpansionTileHostState extends State<SliverExpansionTileHost> {
  late SliverExpansionTileController _controller;
  late Set<String> _sections;

  @override
  void initState() {
    super.initState();
    _controller = SliverExpansionTileController(widget.initialExpanded);
    _controller.addListener(_controllerUpdated);
    _controllerUpdated();
  }

  void _controllerUpdated() {
    setState(() => _sections = _controller._expandedSections.toSet());
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSliverExpansionTile(
      controller: _controller,
      sections: _sections,
      child: widget.child,
    );
  }
}

@immutable
class _InheritedSliverExpansionTile extends InheritedModel<String> {
  const _InheritedSliverExpansionTile({
    required this.controller,
    required this.sections,
    required super.child,
  });

  final SliverExpansionTileController controller;
  final Set<String> sections;

  static SliverExpansionTileController of(BuildContext context, String section) {
    return InheritedModel.inheritFrom<_InheritedSliverExpansionTile>(context, aspect: section)!
        .controller;
  }

  @override
  bool updateShouldNotify(covariant _InheritedSliverExpansionTile oldWidget) {
    return (controller != oldWidget.controller || sections.length != oldWidget.sections.length);
  }

  @override
  bool updateShouldNotifyDependent(
      covariant _InheritedSliverExpansionTile oldWidget, Set<String> dependencies) {
    return (sections.containsAll(dependencies) != oldWidget.sections.containsAll(dependencies));
  }
}

class SliverExpansionTile extends StatelessWidget {
  const SliverExpansionTile({
    super.key,
    required this.section,
    required this.headerBuilder,
    required this.contentBuilder,
  });

  final String section;
  final Widget Function(BuildContext context, String section, bool expanded) headerBuilder;
  final WidgetBuilder contentBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverExpansionTileHeader(
          section: section,
          builder: headerBuilder,
        ),
        SliverExpansionTileContent(
          section: section,
          sliverBuilder: contentBuilder,
        ),
      ],
    );
  }
}

@immutable
class SliverExpansionTileHeader extends StatelessWidget {
  const SliverExpansionTileHeader({
    super.key,
    required this.section,
    required this.builder,
  });

  final String section;
  final Widget Function(BuildContext context, String section, bool expanded) builder;

  @override
  Widget build(BuildContext context) {
    final controller = _InheritedSliverExpansionTile.of(context, section);
    final expanded = controller.isExpanded(section);
    return SliverToBoxAdapter(
      child: IntrinsicHeight(
        child: Material(
          child: InkWell(
            onTap: () => controller.toggleExpanded(section),
            child: builder(context, section, expanded),
          ),
        ),
      ),
    );
  }
}

@immutable
class ExpansionTileChevron extends StatelessWidget {
  const ExpansionTileChevron({
    super.key,
    required this.section,
  });

  final String section;

  @override
  Widget build(BuildContext context) {
    final controller = _InheritedSliverExpansionTile.of(context, section);
    final expanded = controller.isExpanded(section);
    return AppIcon(
      iconAsset: expanded //
          ? Assets.iconChevronUp
          : Assets.iconChevronDown,
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

class _SliverExpansionTileContentState extends State<SliverExpansionTileContent>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _animation;
  late SliverExpansionTileController controller;
  late bool contentVisible;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = _InheritedSliverExpansionTile.of(context, widget.section);
    final expanded = controller.isExpanded(widget.section);
    if (_animationController == null) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        value: expanded ? 1.0 : 0.0,
        vsync: this,
      );
      _animation = _animationController!.drive(
        CurveTween(curve: Curves.fastOutSlowIn),
      );
      _animationController!.addStatusListener(_onStatusChanged);
      contentVisible = expanded;
    } else {
      if (expanded) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController?.removeStatusListener(_onStatusChanged);
    _animationController?.dispose();
    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    setState(() => contentVisible = (status != AnimationStatus.dismissed));
  }

  @override
  Widget build(BuildContext context) {
    return _SliverExpansionTileContent(
      animation: _animation,
      sliver: contentVisible ? widget.sliverBuilder(context) : emptySliver,
    );
  }
}

class _SliverExpansionTileContent extends SingleChildRenderObjectWidget {
  const _SliverExpansionTileContent({
    required this.animation,
    required Widget sliver,
  }) : super(child: sliver);

  final Animation<double> animation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSliverExpansionTileContent(animation: animation);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderSliverExpansionTileContent renderObject,
  ) {
    renderObject.animation = animation;
  }
}

class _RenderSliverExpansionTileContent extends RenderProxySliver {
  _RenderSliverExpansionTileContent({
    required Animation<double> animation,
    RenderSliver? sliver,
  }) {
    this.animation = animation;
    child = sliver;
  }

  Animation<double>? _animation;

  Animation<double> get animation => _animation!;

  set animation(Animation<double> value) {
    if (_animation == value) {
      return;
    }
    if (attached && _animation != null) {
      animation.removeListener(markNeedsLayout);
    }
    _animation = value;
    if (attached) {
      animation.addListener(markNeedsLayout);
    }
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    animation.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    animation.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    final childGeometry = child!.geometry!;
    final childExtent = childGeometry.maxPaintExtent * animation.value;
    final paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow:
          childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childGeometry = child!.geometry!;
    if (geometry!.maxPaintExtent < childGeometry.maxPaintExtent) {
      Rect rect;
      if (constraints.axis == Axis.vertical) {
        rect = Offset(0.0, geometry!.paintOrigin) &
            Size(constraints.crossAxisExtent, geometry!.paintExtent);
      } else {
        rect = Offset(geometry!.paintOrigin, 0.0) &
            Size(geometry!.paintExtent, constraints.crossAxisExtent);
      }
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        rect,
        super.paint,
        clipBehavior: Clip.hardEdge,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      super.paint(context, offset);
    }
  }

  final _clipRectLayer = LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }
}
