import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/home/home_page.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
import 'package:wow_shopping/features/main/widgets/cart_popup_notification.dart';
import 'package:wow_shopping/widgets/common.dart';

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

  static MainScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>()!;
  }

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  NavItem _selected = NavItem.home;

  void gotoSection(NavItem item) {
    setState(() => _selected = item);
  }

  @override
  Widget build(BuildContext context) {
    return CartPopupCountHost(
      child: SizedBox.expand(
        child: Material(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ConnectionMonitor(
                      child: IndexedStack(
                        index: _selected.index,
                        children: [
                          for (final item in NavItem.values) //
                            item.builder(),
                        ],
                      ),
                    ),
                  ),
                  BottomNavBar(
                    onNavItemPressed: gotoSection,
                    selected: _selected,
                  ),
                ],
              ),
              const CartPopupNotification(),
            ],
          ),
        ),
      ),
    );
  }
}
