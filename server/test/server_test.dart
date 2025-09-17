import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:common/common.dart';
import 'package:http/http.dart' as http;
import 'package:server/server.dart';
import 'package:server/server/deployment.dart';
import 'package:test/test.dart';

void main() {
  final port = 8180;
  final host = 'http://localhost:$port';

  final jsonRequestHeaders = {
    HttpHeaders.acceptHeader: '${ContentType.json}',
    HttpHeaders.contentTypeHeader: '${ContentType.json}',
  };

  late ServerApi server;

  Future<R> ignorePrint<R>(R Function() body) async {
    return await runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          // ignore print
        },
      ),
    );
  }

  setUp(() async {
    await ignorePrint(() async {
      server = ServerApi(Deployment.test, port: port);
      await server.start();
    });
  });

  tearDown(() async {
    await ignorePrint(() async {
      await server.stop();
    });
  });

  test('Root requests', () async {
    final response = await http.get(Uri.parse('$host/'));
    expect(response.statusCode, HttpStatus.notFound);
  });

  test('Ping requests', () async {
    final response = await http.get(Uri.parse('$host/ping'));
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, '{"name":"API Server v1"}');
    expect(response.headers, containsPair(HttpHeaders.acceptHeader, '${ContentType.json}'));
    expect(response.headers, containsPair(HttpHeaders.contentTypeHeader, '${ContentType.json}'));
  });

  test('Static file hosting hoddie_001.png', () async {
    final response = await http.get(Uri.parse('$host/static/hoodie_001.png'));
    final expectedBytes = File('data/hoodie_001.png').readAsBytesSync();
    expect(response.statusCode, HttpStatus.ok);
    expect(response.bodyBytes, equals(expectedBytes));
  });

  test('Static file hosting missing', () async {
    final response = await http.get(Uri.parse('$host/static/unknown_test_file'));
    expect(response.statusCode, HttpStatus.notFound);
  });

  test('API Auth: Login (Bad Request)', () async {
    final response = await http.post(
      Uri.parse('$host/api/auth/login'),
      body: '',
    );
    expect(response.statusCode, HttpStatus.badRequest);
  });

  Future<http.Response> performLogin() async {
    final loginRequest = LoginRequest(username: 'fred', password: 'password');
    return await http.post(
      Uri.parse('$host/api/auth/login'),
      body: json.encode(loginRequest),
      headers: jsonRequestHeaders,
    );
  }

  test('API Auth: Login (Success)', () async {
    final actualResponse = await performLogin();
    final expectedResponse = LoginResponse(
      accessToken: 'abc123',
      user: UserDto(id: '1', name: 'Fred'),
    );
    expect(actualResponse.statusCode, HttpStatus.ok, reason: actualResponse.body);
    expect(actualResponse.body, json.encode(expectedResponse));
  });

  test('API Auth Middleware: Missing header', () async {
    final actualResponse = await http.post(
      Uri.parse('$host/api/products/all'),
      headers: {
        ...jsonRequestHeaders,
      },
    );
    expect(actualResponse.statusCode, HttpStatus.badRequest, reason: actualResponse.body);
    expect(actualResponse.body, contains('Missing authentication'));
  });

  test('API Auth Middleware: Bad auth token', () async {
    final actualResponse = await http.post(
      Uri.parse('$host/api/products/all'),
      headers: {
        ...jsonRequestHeaders,
        HttpHeaders.authorizationHeader: 'something-incorrect',
      },
    );
    expect(actualResponse.statusCode, HttpStatus.badRequest, reason: actualResponse.body);
    expect(actualResponse.body, contains('Bad authentication token'));
  });

  test('API Auth Middleware: Invalid auth token', () async {
    final actualResponse = await http.post(
      Uri.parse('$host/api/products/all'),
      headers: {
        ...jsonRequestHeaders,
        HttpHeaders.authorizationHeader: 'Bearer something-incorrect',
      },
    );
    expect(actualResponse.statusCode, HttpStatus.forbidden, reason: actualResponse.body);
    expect(actualResponse.body, contains('Invalid authentication token'));
  });

  test('API Auth: Logout', () async {
    final actualLoginResponse = await performLogin();
    final loginResponse = LoginResponse.fromJson(
      json.decode(actualLoginResponse.body),
    );
    final response = await http.post(
      Uri.parse('$host/api/auth/logout'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${loginResponse.accessToken}',
        ...jsonRequestHeaders,
      },
    );
    expect(response.statusCode, HttpStatus.ok, reason: response.body);
  });
}
