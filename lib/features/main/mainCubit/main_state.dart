part of 'main_cubit.dart';

@immutable
class MainState {
  final NavItem selected;

  const MainState({this.selected = NavItem.home});
}
