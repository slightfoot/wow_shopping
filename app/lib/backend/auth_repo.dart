import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/models/auth_state.dart';
import 'package:wow_shopping/models/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class AuthRepo {
  AuthRepo(this._apiService, this._file, this._authState);

  final ApiService _apiService;
  final File _file;
  AuthState _authState;

  Timer? _saveTimer;
  late StreamController<User> _userController;

  Stream<User> get streamUser => _userController.stream;

  User get currentUser => _authState.user;

  Stream<bool> get streamIsLoggedIn => _userController.stream //
      .map((user) => user != User.none);

  bool get isLoggedIn => _authState.user != User.none;

  String get token => _authState.accessToken;

  static Future<AuthRepo> create(ApiService apiService) async {
    AuthState authState;
    File file;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      file = File(path.join(dir.path, 'auth_state.json'));
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
    try {
      if (await file.exists()) {
        authState = AuthState.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        authState = AuthState.none;
      }
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      file.delete();
      authState = AuthState.none;
    }
    return AuthRepo(apiService, file, authState)..init();
  }

  void init() {
    _userController = StreamController<User>.broadcast(
      onListen: () => _userController.add(_authState.user),
    );
  }

  void retrieveUser() {
    // currentUser = apiService.fetchUser();
    // _saveUser();
  }

  void _updateAuthState(AuthState state) {
    _authState = state;
    _userController.add(_authState.user);
    _saveAuthState();
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      _updateAuthState(AuthState(
        accessToken: response.accessToken,
        user: User.fromDto(response.user),
      ));
    } catch (error, stackTrace) {
      print('$error\n$stackTrace');
      // FIXME: show user error, change state? rethrow?
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (error, stackTrace) {
      print('$error\n$stackTrace');
      // FIXME: failed to logout? report to server
    }
    _updateAuthState(AuthState.none);
  }

  void _saveAuthState() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      if (_authState == AuthState.none) {
        if (_file.existsSync()) {
          await _file.delete();
        }
      } else {
        await _file.writeAsString(
          json.encode(_authState.toJson()),
        );
      }
    });
  }
}
