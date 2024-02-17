import 'dart:async';
import 'dart:io';

import 'package:server/api/auth/auth_api.dart';
import 'package:server/api/auth/auth_middleware.dart';
import 'package:server/api/exception_middleware.dart';
import 'package:server/api/products/products_api.dart';
import 'package:server/server/deployment.dart';
import 'package:server/utils/json.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart' as shelf_static;

class ServerApi {
  ServerApi(this._deployment);

  final Deployment _deployment;
  late HttpServer _httpServer;
  late StreamSubscription _quitSignal;
  bool _initialized = false;

  late final _router = Router()
    ..get('/ping', _pingHandler)
    ..mount(
      '/static',
      shelf_static.createStaticHandler(
        '${Directory.current.path}/data',
      ),
    )
    ..mount('/api/auth', AuthApi())
    ..mount(
        '/api/products',
        Pipeline() //
            .addMiddleware(const AuthMiddleware())
            .addHandler(ProductsApi()));

  Future<void> start() async {
    if (_initialized) {
      return;
    }

    _quitSignal = ProcessSignal.sigint.watch().listen((_) => stop());

    final pipeline = Pipeline() //
        .addMiddleware(logRequests())
        .addMiddleware(ExceptionMiddleware(_deployment))
        .addHandler(_router);

    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    _httpServer = await shelf_io.serve(
      pipeline,
      InternetAddress.anyIPv4,
      port,
    );
    print('Server listening on port ${_httpServer.port}');
    _initialized = true;
  }

  Future<void> stop() async {
    if (!_initialized) {
      return;
    }
    print('Server is shutting down...');
    await _httpServer.close();
    await _quitSignal.cancel();
    _initialized = false;
  }

  Response _pingHandler(Request request) {
    return jsonResponse({'name': 'API Server v1'});
  }
}
