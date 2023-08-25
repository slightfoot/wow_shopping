import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';

export 'package:wow_shopping/models/category_item.dart';

@immutable
class TopNavBar extends StatelessWidget {
  const TopNavBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;
    final useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
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
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (canPop) //
                        Align(
                          alignment: Alignment.centerLeft,
                          child: useCloseButton ? const CloseButton() : const BackButton(),
                        ),
                      DefaultTextStyle.merge(
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        child: title,
                      ),
                      if (actions case List<Widget> actions) //
                        Align(
                          alignment: Alignment.centerRight,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: actions,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (bottom case Widget bottom) //
                  bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class SliverTopNavBar extends StatelessWidget {
  const SliverTopNavBar({
    super.key,
    required this.title,
    this.actions,
    this.pinned = false,
    this.floating = false,
  });

  final Widget title;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return SliverPersistentHeader(
      delegate: _SliverTopNavBarDelegate(
        viewPadding: viewPadding,
        title: title,
        actions: actions,
      ),
      pinned: pinned,
      floating: floating,
    );
  }
}

class _SliverTopNavBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTopNavBarDelegate({
    required this.viewPadding,
    required this.title,
    this.actions,
  });

  final EdgeInsets viewPadding;
  final Widget title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appTheme = AppTheme.of(context);
    final amount = (shrinkOffset / (maxExtent - minExtent));
    return OverflowBox(
      minHeight: minExtent,
      maxHeight: maxExtent,
      alignment: Alignment.bottomCenter,
      child: AnnotatedRegion(
        value: appOverlayLightIcons,
        child: Material(
          color: appTheme.appBarColor,
          elevation: amount != 0.0 ? 4.0 : 0.0,
          child: Transform.translate(
            offset: Offset(0.0, -minExtent * amount),
            child: TopNavBar(
              title: title,
              actions: actions,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get minExtent => viewPadding.top;

  @override
  double get maxExtent => viewPadding.top + 48.0;

  @override
  bool shouldRebuild(covariant _SliverTopNavBarDelegate oldDelegate) {
    return title != oldDelegate.title || listEquals(actions, oldDelegate.actions);
  }
}
