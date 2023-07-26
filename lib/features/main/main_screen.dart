import 'package:flutter/material.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
    return SizedBox.expand(
      child: Material(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selected.index,
                children: [
                  for (final item in NavItem.values) //
                    item.builder(),
                ],
              ),
            ),
            BottomNavBar(
              onNavItemPressed: gotoSection,
              selected: _selected,
            ),
          ],
        ),
      ),
    );
  }
}
