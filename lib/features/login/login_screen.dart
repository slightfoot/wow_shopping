import 'package:flutter/material.dart';
import 'login_option_screen.dart';
import 'login_page_wrapper.dart';

import '../../app/theme.dart';
import '../../backend/backend.dart';

import 'widgets/gender_selection_view.dart';
import 'login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const LoginScreen._(),
        );
      },
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final _logic = LoginLogic(authRepo);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return StreamBuilder<LoginState>(
      initialData: _logic.currentState,
      stream: _logic.streamState,
      builder: (BuildContext context, AsyncSnapshot<LoginState> snapshot) {
        final state = snapshot.requireData;
        //todo: redirect to home if logged in
        return LogInPageWrapper(
          child: GenderSelectionView(onContinue: _onContinue),
        );
      },
    );
  }

  _onContinue(String? p1) {
    Navigator.of(context).push(
      LoginToYourAccountWidget.route(p1),
    );
  }
}
