import 'package:common/common.dart';
import 'package:server/api/auth/auth_middleware.dart';
import 'package:server/api/exception.dart';
import 'package:server/utils/json.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthApi {
  AuthApi();

  Future<Response> call(Request request) async => await _router(request);

  late final _router = Router()
    ..post('/login', _login) //
    ..post(
      '/logout',
      Pipeline() //
          .addMiddleware(const AuthMiddleware())
          .addHandler(_logout),
    );

  Future<Response> _login(Request request) async {
    final body = await jsonRequest(request, LoginRequest.fromJson);
    if (body.username.trim().isEmpty) {
      throw ApiException.badRequest('Missing username');
    }
    if (body.password.trim().isEmpty) {
      throw ApiException.badRequest('Missing password');
    }
    // TODO: look up user in database and check password hash?
    if (body.username != 'fred' || body.password != 'password') {
      throw ApiException.unauthorized('Incorrect username/password');
    }
    return jsonResponse(
      LoginResponse(
        accessToken: 'abc123',
        user: UserDto(id: '1', name: 'Fred'),
      ),
    );
  }

  Future<Response> _logout(Request request) async {
    final user = AuthMiddleware.userOf(request);
    print('User ${user.id} logging out');
    // TODO: remove accessToken from user account
    return jsonResponse({});
  }
}
