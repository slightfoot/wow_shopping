import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/nav_item.dart';

class BottomNavbarStateNotifer extends StateNotifier<NavItem> {
  BottomNavbarStateNotifer() : super(NavItem.home);

  void gotoSection(NavItem item) {
    state = item;
  }
}

final bottomNavbarProvider = StateNotifierProvider<BottomNavbarStateNotifer, NavItem>(
  (ref) => BottomNavbarStateNotifer(),
);