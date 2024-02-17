import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

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
    return Material(
      child: Center(
        child: StreamBuilder<LoginState>(
          initialData: _logic.currentState,
          stream: _logic.streamState,
          builder: (BuildContext context, AsyncSnapshot<LoginState> snapshot) {
            final state = snapshot.requireData;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  onPressed: state.isLoading ? null : _logic.onLoginPressed,
                  label: 'Login',
                ),
                verticalMargin16,
                if (state.isLoading) //
                  const CircularProgressIndicator(),
                if (state.hasError) //
                  Text(state.lastError),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LoginLogic {
  LoginLogic(this._authRepo) {
    _stateController = StreamController<LoginState>.broadcast(
      onListen: () => _emitState(_state),
    );
  }

  final AuthRepo _authRepo;
  late StreamController<LoginState> _stateController;
  var _state = LoginState.initial();

  LoginState get currentState => _state;

  Stream<LoginState> get streamState => _stateController.stream;

  void _emitState(LoginState value) {
    _state = value;
    _stateController.add(value);
  }

  Future<void> onLoginPressed() async {
    _emitState(LoginState.loading());
    try {
      await _authRepo.login('username', 'password');
    } catch (error) {
      _emitState(LoginState.error(error));
    }
  }
}

class LoginState {
  LoginState.initial()
      : isLoading = false,
        lastError = '';

  LoginState.loading()
      : isLoading = true,
        lastError = '';

  LoginState.error(dynamic error)
      : isLoading = false,
        lastError = error.toString();

  final bool isLoading;
  final String lastError;

  bool get hasError => lastError.isNotEmpty;
}
