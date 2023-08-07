// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:wow_shopping/features/main/main_screen.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  void gotoSelection(NavItem item) {
    emit(MainState(selected: item));
  }
}
