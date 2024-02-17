import 'dart:io';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message, {this.code = 0});

  final int statusCode;
  final int code;
  final String message;

  factory ApiException.badRequest(String message) {
    return ApiException(HttpStatus.badRequest, message);
  }

  factory ApiException.permissionDenied({String? message}) {
    return ApiException(
      HttpStatus.forbidden,
      message ?? 'Permission denied',
    );
  }

  factory ApiException.notFound(String message) {
    return ApiException(HttpStatus.notFound, message);
  }
}
