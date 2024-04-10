import 'dart:io';

import 'package:server/api/exception.dart';
import 'package:server/models/user.dart';
import 'package:shelf/shelf.dart';

class AuthMiddleware {
  const AuthMiddleware();

  static const _authUser = 'auth/user';

  static User userOf(Request request) {
    return request.context[_authUser] as User;
  }

  Handler call(Handler innerHandler) {
    return (Request request) async {
      final authHeaderRaw = request.headers[HttpHeaders.authorizationHeader];
      if (authHeaderRaw == null) {
        throw ApiException.badRequest('Missing authentication');
      }
      if (authHeaderRaw.toLowerCase().startsWith('bearer ') == false) {
        throw ApiException.badRequest('Bad authentication token');
      }

      // TODO: lookup/decode and validate our [authToken]
      final authToken = authHeaderRaw.substring('bearer '.length);
      if (authToken != 'abc123') {
        throw ApiException.permissionDenied(message: 'Invalid authentication token');
      }

      // TODO: lookup user from [authToken]
      final user = User(id: '1', name: 'Fred');

      return await innerHandler(request.change(
        context: {
          _authUser: user,
        },
      ));
    };
  }
}
