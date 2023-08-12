import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
import 'package:wow_shopping/shared/command_error_filters.dart';

export 'package:wow_shopping/features/main/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
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
    registerHandler(
      select: (InteractionManager m) => m.lastMessage,
      handler: (context, newValue, cancel) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(newValue.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      cancel();
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              )),
    );
    return SizedBox.expand(
      child: Material(
        child: Column(
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
      ),
    );
  }
}
