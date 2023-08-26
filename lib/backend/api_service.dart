import 'package:wow_shopping/models/user.dart';

typedef TokenProvider = Future<String> Function();

class ApiService {
  ApiService(this.tokenProvider);

  final TokenProvider tokenProvider;

  Future<User> login(String username, String password) async {
    // FIXME: call to server and login
    return User.fromJson(await doNetworkRequest(
      '/login',
      body: {
        'username': username,
        'password': password,
      },
    ));
  }

  Future<void> logout() async {
    // FIXME: call to server to to invalidate token
    doNetworkRequest('/logout');
  }

  Future<Map<String, dynamic>> doNetworkRequest(String path, {Map<String, dynamic>? body}) async {
    final token = await tokenProvider();
    await Future.delayed(const Duration(seconds: 2));
    // FIXME: perform network request with token
    if (path == '/login') {
      return {'id': '123', 'name': 'Michael'};
    } else {
      return {};
    }
  }
}
