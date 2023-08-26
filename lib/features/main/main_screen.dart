import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
import 'package:wow_shopping/widgets/child_builder.dart';

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            ChildBuilder(
              builder: (context, child) {
                final data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(
                    viewInsets: EdgeInsets.only(
                      bottom: math.max(data.viewInsets.bottom, 64.0),
                    ),
                  ),
                  child: child,
                );
              },
              child: IndexedStack(
                index: _selected.index,
                children: [
                  for (final item in NavItem.values) //
                    item.builder(),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: BottomNavBar(
                onNavItemPressed: gotoSection,
                selected: _selected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
