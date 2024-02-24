import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/home/home_page.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
import 'package:wow_shopping/features/main/widgets/cart_popup_notification.dart';
import 'package:wow_shopping/features/main/widgets/side_nav_bar.dart';
import 'package:wow_shopping/features/product_details/product_page.dart';
import 'package:wow_shopping/models/product_item.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget {
  const MainScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const MainScreen._(),
        );
      },
    );
  }

  static Future<void> precacheImages() async {
    await HomePage.precacheImages();
    await BottomNavBar.precacheImages();
  }

  static MainScreenState _of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>()!;
  }

  @override
  State<MainScreen> createState() => MainScreenState();
}

extension BuildContextNavigationExtension on BuildContext {
  MainScreenState get mainScreen => MainScreen._of(this);
}

class MainScreenState extends State<MainScreen> {
  final _contentKey = GlobalKey(debugLabel: 'content');

  NavItem _selected = NavItem.home;

  bool? _horizontalNavigationStyle;
  bool _detailsOpen = false;
  Widget? _detailsPanel;

  void gotoSection(NavItem item) {
    setState(() => _selected = item);
  }

  Future<void> openProduct(ProductItem item) async {
    if (_horizontalNavigationStyle!) {
      setState(() {
        _detailsPanel = ProductPage(
          key: Key('product-${item.id}'),
          item: item,
        );
        _detailsOpen = true;
      });
    } else {
      await Navigator.of(context).push(
        ProductPage.route(item),
      );
    }
  }

  void goBack() {
    if (_detailsOpen) {
      setState(() => _detailsOpen = false);
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CartPopupCountHost(
      child: SizedBox.expand(
        child: Material(
          child: ConnectionMonitor(
            child: Stack(
              children: [
                DeviceTypeBuilder(
                  builder: (BuildContext context, DeviceTypeOrientationState state, Widget? child) {
                    _horizontalNavigationStyle = (state.isTablet && state.isLandscape);
                    if (_horizontalNavigationStyle!) {
                      return _TabletLayout(
                        opened: _detailsOpen,
                        panel: _detailsPanel,
                        child: child!,
                      );
                    } else {
                      return _VerticalLayout(
                        child: child!,
                      );
                    }
                  },
                  child: IndexedStack(
                    key: _contentKey,
                    index: _selected.index,
                    children: [
                      for (final item in NavItem.values) //
                        item.builder(),
                    ],
                  ),
                ),
                const CartPopupNotification(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabletLayout extends StatefulWidget {
  const _TabletLayout({
    required this.opened,
    required this.panel,
    required this.child,
  });

  final bool opened;
  final Widget? panel;
  final Widget child;

  @override
  State<_TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<_TabletLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SideNavBar(
              onNavItemPressed: context.mainScreen.gotoSection,
              selected: context.mainScreen._selected,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  RepaintBoundary(
                    child: widget.child,
                  ),
                  if (widget.panel != null) //
                    AnimatedAlign(
                      widthFactor: widget.opened ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.4,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: -4.0,
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: widget.panel!,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: child
        ),
        BottomNavBar(
          onNavItemPressed: context.mainScreen.gotoSection,
          selected: context.mainScreen._selected,
        ),
      ],
    );
  }
}
