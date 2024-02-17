import 'dart:convert';
import 'dart:io';

import 'package:common/common.dart';
import 'package:http/http.dart' as http;

typedef TokenProvider = Future<String> Function();

class ApiService {
  ApiService(String baseApiUrl, this.tokenProvider) {
    baseUri = Uri.parse(baseApiUrl);
  }

  late final Uri baseUri;
  final TokenProvider tokenProvider;

  Future<T> _post<T>(
    String path, {
    dynamic body,
    T Function(Map<String, dynamic> body)? fromJson,
  }) async {
    final token = await tokenProvider();
    if (body != null && (body is! Map || body is! List)) {
      body = body.toJson();
    }
    final response = await http.post(
      baseUri.replace(path: path),
      headers: {
        HttpHeaders.acceptHeader: '${ContentType.json}',
        HttpHeaders.contentTypeHeader: '${ContentType.json}',
        if (token.isNotEmpty) //
          HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: body != null ? json.encode(body) : null,
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('API Exception: ${response.statusCode}: ${response.body}');
    }
    final contentTypeRaw = response.headers[HttpHeaders.contentTypeHeader];
    if (contentTypeRaw == null) {
      throw Exception('No content type in response');
    }
    final contentType = ContentType.parse(contentTypeRaw);
    if (contentType.mimeType != ContentType.json.mimeType) {
      throw Exception('Unacceptable content type: $contentType');
    }
    if (fromJson != null) {
      return fromJson(
        (json.decode(response.body) as Map) //
            .cast<String, dynamic>(),
      );
    }
    final responseType = _typeOf<T>();
    if (responseType != Null) {
      throw 'Missing required fromJson for type: $responseType';
    }
    return {} as T; // ugh!
  }

  static Type _typeOf<T>() => T;

  Future<LoginResponse> login(String username, String password) async {
    return await _post(
      '/api/auth/login',
      fromJson: LoginResponse.fromJson,
      body: LoginRequest(
        username: username,
        password: password,
      ),
    );
  }

  Future<void> logout() async {
    return await _post('/api/auth/logout');
  }

  Future<List<ProductDto>> getProducts() async {
    return await _post(
      '/api/products/all',
      fromJson: (json) {
        return (json['products'] as List) //
            .cast<Map<String, dynamic>>()
            .map(ProductDto.fromJson)
            .toList();
      },
    );
  }

  Future<List<ProductDto>> getTopSellingProducts() async {
    return await _post(
      '/api/products/top-selling',
      fromJson: (json) {
        return (json['products'] as List) //
            .cast<Map<String, dynamic>>()
            .map(ProductDto.fromJson)
            .toList();
      },
    );
  }

  Future<List<int>> getFeaturedCategories() async {
    return await _post(
      '/api/products/featured-categories',
      fromJson: (json) {
        return (json['featured_categories'] as List) //
            .cast<int>()
            .toList();
      },
    );
  }
}
