import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/providers/bottom_navbar_provider.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(bottomNavbarProvider);
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: selected.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              onNavItemPressed: ref.read(bottomNavbarProvider.notifier).gotoSection,
              selected: selected,
            ),
          ],
        ),
      ),
    );
  }
}
