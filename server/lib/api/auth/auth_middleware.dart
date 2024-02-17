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
      final authToken = authHeaderRaw.substring('bearer '.length);
      if (authToken.isEmpty) {
        throw ApiException.badRequest('Bad bearer token');
      }
      // TODO: lookup/decode and validate our [authToken]
      if (authToken != 'abc123') {
        throw ApiException.permissionDenied();
      }
      // TODO: lookup user from [authToken]
      final user = User(id: '1');

      return await innerHandler(request.change(
        context: {
          _authUser: user,
        },
      ));
    };
  }
}
