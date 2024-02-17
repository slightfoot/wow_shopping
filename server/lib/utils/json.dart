import 'dart:convert';
import 'dart:io';

import 'package:server/api/exception.dart';
import 'package:shelf/shelf.dart';

Future<T> jsonRequest<T>(Request request, T Function(Map<String, dynamic> body) fromJson) async {
  final contentTypeRaw = request.headers[HttpHeaders.contentTypeHeader];
  if (contentTypeRaw == null) {
    throw ApiException.badRequest('No content type');
  }
  final contentType = ContentType.parse(contentTypeRaw);
  if (contentType.mimeType != ContentType.json.mimeType) {
    throw ApiException.badRequest('Unacceptable content type');
  }
  try {
    final body = await request.readAsString();
    return fromJson(json.decode(body));
  } catch (error, stackTrace) {
    print('Invalid request body\n$error\n$stackTrace');
    throw ApiException.badRequest('Invalid JSON body');
  }
}

Response jsonResponse(dynamic object, {int statusCode = HttpStatus.ok}) {
  if(object is! Map && object is! List) {
    object = object.toJson();
  }
  return Response(
    statusCode,
    body: json.encode(object),
    headers: {
      HttpHeaders.acceptHeader: '${ContentType.json}',
      HttpHeaders.contentTypeHeader: '${ContentType.json}',
    },
  );
}
