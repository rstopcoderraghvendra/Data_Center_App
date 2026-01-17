import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../storage/local_storage.dart';

class ApiClient {
  final String baseUrl;
  final LocalStorage storage;

  ApiClient({
    this.baseUrl = ApiEndpoints.baseUrl,
    required this.storage,
  });

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    log('url: $uri');
    final headers = await _headers();
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers();
    final response = await http.post(
      uri,
      headers: headers,
      body: body == null ? null : jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers();
    final response = await http.put(
      uri,
      headers: headers,
      body: body == null ? null : jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<void> setToken(String token) async {
    await storage.save('token', token);
  }

  Future<String?> getToken() async {
    return storage.read('token');
  }

  Future<void> clearToken() async {
    await storage.remove('token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await getToken();
    log('token: $token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isEmpty ? '{}' : response.body;
    final decoded = jsonDecode(body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }
    final message =
        decoded is Map<String, dynamic> && decoded['message'] != null
            ? decoded['message'].toString()
            : 'Request failed';
    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
