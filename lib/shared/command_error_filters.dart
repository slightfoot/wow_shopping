import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';

class ApiException implements Exception {
  ApiException(this.code, this.message);

  ApiException.withInner(
      this.code, this.message, this.innerException, this.stackTrace);

  int code = 0;
  String? message;
  Exception? innerException;
  StackTrace? stackTrace;

  @override
  String toString() {
    if (message == null) {
      return 'ApiException';
    }
    if (innerException == null) {
      return 'ApiException $code: $message';
    }
    return 'ApiException $code: $message (Inner exception: $innerException)\n\n$stackTrace';
  }
}

class ErrorFilterFunction extends ErrorFilter {
  ErrorFilterFunction(this.filterFunction);

  final ErrorReaction Function(Object error) filterFunction;
  @override
  ErrorReaction filter(Object error, StackTrace stackTrace) {
    return filterFunction(error);
  }
}

class LocalOnlyErrorFilter extends ErrorFilter {
  @override
  ErrorReaction filter(Object error, StackTrace stackTrace) {
    return ErrorReaction.localHandler;
  }
}

class ApiErrorLocalFilter implements ErrorFilter {
  ApiErrorLocalFilter(
    this.errorCodesHandled, [
    this.reaction = ErrorReaction.localHandler,
  ]);
  final List<int> errorCodesHandled;
  final ErrorReaction reaction;

  @override
  ErrorReaction filter(Object error, s) {
    if (error is ApiException) {
      if (errorCodesHandled.isEmpty || errorCodesHandled.contains(error.code)) {
        return ErrorReaction.localHandler;
      }
    }
    return ErrorReaction.globalHandler;
  }
}

class InteractionManager {
  ValueNotifier<String> lastMessage = ValueNotifier<String>('');
  void showMessage(String message) {
    lastMessage.value = message;
  }
}
