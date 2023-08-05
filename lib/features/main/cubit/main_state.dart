part of 'main_cubit.dart';

@immutable
class MainState {
  const MainState({this.selected = NavItem.home});

  final NavItem selected;
}
