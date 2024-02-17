import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/models/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class AuthRepo {
  AuthRepo(this._apiService, this._file, this._currentUser);

  final ApiService _apiService;
  final File _file;
  User _currentUser;

  Timer? _saveTimer;
  late StreamController<User> _userController;

  Stream<User> get streamUser => _userController.stream;

  User get currentUser => _currentUser;

  Stream<bool> get streamIsLoggedIn => _userController.stream //
      .map((user) => user != User.none);

  bool get isLoggedIn => _currentUser != User.none;

  // FIXME: this should come from storage
  String get token => '123';

  static Future<AuthRepo> create(ApiService apiService) async {
    User currentUser;
    File file;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      file = File(path.join(dir.path, 'user.json'));
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
    try {
      if (await file.exists()) {
        currentUser = User.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        currentUser = User.none;
      }
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      file.delete();
      currentUser = User.none;
    }
    return AuthRepo(apiService, file, currentUser)..init();
  }

  void init() {
    _userController = StreamController<User>.broadcast(
      onListen: () => _emitUser(_currentUser),
    );
  }

  void _emitUser(User value) {
    _currentUser = value;
    _userController.add(value);
    _saveUser();
  }

  Future<void> login(String username, String password) async {
    try {
      _emitUser(await _apiService.login(username, password));
    } catch (error) {
      // FIXME: show user error, change state? rethrow?
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (error) {
      // FIXME: failed to logout? report to server
    }
    _emitUser(User.none);
  }

  void retrieveUser() {
    // currentUser = apiService.fetchUser();
    // _saveUser();
  }

  void _saveUser() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      if (_currentUser == User.none) {
        await _file.delete();
      } else {
        await _file.writeAsString(json.encode(_currentUser.toJson()));
      }
    });
  }
}
