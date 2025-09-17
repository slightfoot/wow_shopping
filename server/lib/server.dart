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
  ServerApi(this._deployment, {int? port}) : _port = port;

  final Deployment _deployment;
  final int? _port;

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
          .addHandler(ProductsApi()),
    );

  Future<void> start() async {
    if (_initialized) {
      return;
    }

    _quitSignal = ProcessSignal.sigint.watch().listen((_) => stop());

    var pipeline = Pipeline();
    if (_deployment != Deployment.test) {
      pipeline = pipeline.addMiddleware(logRequests());
    }
    final handler =
        pipeline //
            .addMiddleware(ExceptionMiddleware(_deployment))
            .addHandler(_router);

    // Use the port given, otherwise extract from process environment
    // or default to 8080.
    final port =
        _port ?? //
        int.parse(Platform.environment['PORT'] ?? '8080');

    _httpServer = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);

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
