
part of 'login_bloc.dart';

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
