import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/home/home_page.dart';
import 'package:wow_shopping/features/main/main_navigation.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
import 'package:wow_shopping/features/main/widgets/cart_popup_notification.dart';
import 'package:wow_shopping/features/main/widgets/side_nav_bar.dart';
import 'package:wow_shopping/features/product_details/product_page.dart';
import 'package:wow_shopping/models/product_item.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const routeName = '/main';

  static Route<void> route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const MainScreen(),
        );
      },
    );
  }

  static Future<void> precacheImages() async {
    await HomePage.precacheImages();
    await BottomNavBar.precacheImages();
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with RestorationMixin implements MainNavigation {
  final _contentKey = GlobalKey(debugLabel: 'content');

  @override
  String? get restorationId => 'main_screen';

  final _selected = RestorableEnum<NavItem>(
    NavItem.home,
    values: NavItem.values,
  );

  bool? _horizontalNavigationStyle;
  bool _detailsOpen = false;
  Widget? _detailsPanel;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selected, 'selected');
  }

  @override
  void gotoSection(NavItem item) {
    setState(() => _selected.value = item);
  }

  @override
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
        ProductPage.route(item, mainNavigation: this),
      );
    }
  }

  @override
  void goBack() {
    if (_detailsOpen) {
      setState(() => _detailsOpen = false);
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavHost(
      mainNavigation: this,
      child: CartPopupCountHost(
        child: SizedBox.expand(
          child: Material(
            child: ConnectionMonitor(
              child: Stack(
                children: [
                  DeviceTypeBuilder(
                    builder:
                        (BuildContext context, DeviceTypeOrientationState state, Widget? child) {
                      _horizontalNavigationStyle = (state.isTablet && state.isLandscape);
                      if (_horizontalNavigationStyle!) {
                        return _TabletLayout(
                          selected: _selected.value,
                          opened: _detailsOpen,
                          panel: _detailsPanel,
                          child: child!,
                        );
                      } else {
                        return _VerticalLayout(
                          selected: _selected.value,
                          child: child!,
                        );
                      }
                    },
                    child: IndexedStack(
                      key: _contentKey,
                      index: _selected.value.index,
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
      ),
    );
  }
}

class _TabletLayout extends StatefulWidget {
  const _TabletLayout({
    required this.selected,
    required this.opened,
    required this.panel,
    required this.child,
  });

  final NavItem selected;
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
              onNavItemPressed: context.mainNav.gotoSection,
              selected: widget.selected,
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
    required this.selected,
    required this.child,
  });

  final NavItem selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        BottomNavBar(
          onNavItemPressed: context.mainNav.gotoSection,
          selected: selected,
        ),
      ],
    );
  }
}
