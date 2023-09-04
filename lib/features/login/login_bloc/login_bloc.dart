import '../../../backend/auth_repo.dart';

import 'dart:async';

part 'login_state.dart';

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
