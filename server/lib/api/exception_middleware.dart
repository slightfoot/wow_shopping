import 'dart:io';

import 'package:server/api/exception.dart';
import 'package:server/server/deployment.dart';
import 'package:server/utils/json.dart';
import 'package:shelf/shelf.dart';
import 'package:stack_trace/stack_trace.dart';

class ExceptionMiddleware {
  const ExceptionMiddleware(this._deployment);

  final Deployment _deployment;

  Handler call(Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        String message = 'An error occurred';
        int code = 0;
        int statusCode = HttpStatus.internalServerError;
        if (error is ApiException) {
          message = error.message;
          code = error.code;
          statusCode = error.statusCode;
        }
        if (_deployment != Deployment.test) {
          print('$error\n$stackTrace');
        }
        return jsonResponse(
          statusCode: statusCode,
          {
            'message': message,
            if (code != 0) //
              'code': code,
            if (_deployment == Deployment.dev) ...{
              'error': '$error',
              if (stackTrace != StackTrace.empty) //
                'stack_trace': [
                  for (final frame in Trace.from(stackTrace).frames) //
                    '$frame',
                ],
            },
          },
        );
      }
    };
  }
}
