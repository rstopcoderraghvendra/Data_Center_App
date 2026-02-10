// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../constants/api_endpoints.dart';
// import '../storage/local_storage.dart';

// class ApiClient {
//   final String baseUrl;
//   final LocalStorage storage;

//   ApiClient({
//     this.baseUrl = ApiEndpoints.baseUrl,
//     required this.storage,
//   });

//   Future<Map<String, dynamic>> getJson(
//     String path, {
//     Map<String, String>? query,
//   }) async {
//     final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
//     log('url: $uri');
//     try {
//       final headers = await _headers();
//       final response = await http.get(uri, headers: headers);
//       return _handleResponse(response);
//     } on SocketException {
//       throw ApiException('Unable to connect to server', 0);
//     }
//   }

//   Future<Map<String, dynamic>> postJson(
//     String path, {
//     Map<String, dynamic>? body,
//   }) async {
//     final uri = Uri.parse('$baseUrl$path');
//     try {
//       final headers = await _headers();
//       final response = await http.post(
//         uri,
//         headers: headers,
//         body: body == null ? null : jsonEncode(body),
//       );
//       return _handleResponse(response);
//     } on SocketException {
//       throw ApiException('Unable to connect to server', 0);
//     }
//   }

//   Future<Map<String, dynamic>> putJson(
//     String path, {
//     Map<String, dynamic>? body,
//   }) async {
//     final uri = Uri.parse('$baseUrl$path');
//     try {
//       final headers = await _headers();
//       final response = await http.put(
//         uri,
//         headers: headers,
//         body: body == null ? null : jsonEncode(body),
//       );
//       return _handleResponse(response);
//     } on SocketException {
//       throw ApiException('Unable to connect to server', 0);
//     }
//   }

//   Future<void> setToken(String token) async {
//     await storage.save('token', token);
//   }

//   Future<String?> getToken() async {
//     return storage.read('token');
//   }

//   Future<void> clearToken() async {
//     await storage.remove('token');
//   }

//   Future<Map<String, String>> _headers() async {
//     final token = await getToken();
//     log('token: $token');
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     if (token != null && token.isNotEmpty) {
//       headers['Authorization'] = 'Bearer $token';
//     }
//     return headers;
//   }

//   Future<Map<String, dynamic>> deleteJson(String path) async {
//     final uri = Uri.parse('$baseUrl$path');
//     try {
//       final headers = await _headers();
//       final response = await http.delete(uri, headers: headers);
//       return _handleResponse(response);
//     } on SocketException {
//       throw ApiException('Unable to connect to server', 0);
//     }
//   }

//   Map<String, dynamic> _handleResponse(http.Response response) {
//     final body = response.body.isEmpty ? '{}' : response.body;
//     final decoded = jsonDecode(body);
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       if (decoded is Map<String, dynamic>) {
//         return decoded;
//       }
//       return {'data': decoded};
//     }
//     final message =
//         decoded is Map<String, dynamic> && decoded['message'] != null
//             ? decoded['message'].toString()
//             : 'Request failed';
//     throw ApiException(message, response.statusCode);
//   }
// }

// class ApiException implements Exception {
//   final String message;
//   final int statusCode;

//   ApiException(this.message, this.statusCode);

//   @override
//   String toString() => 'ApiException($statusCode): $message';
// }

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
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
    developer.log('GET URL: $uri');
    try {
      final headers = await _headers();
      final response = await http.get(uri, headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Unable to connect to server', 0);
    }
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    developer.log('POST URL: $uri');
    developer.log('POST Body: $body');
    try {
      final headers = await _headers();
      final response = await http.post(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Unable to connect to server', 0);
    }
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    developer.log('PUT URL: $uri');
    developer.log('PUT Body: $body');
    try {
      final headers = await _headers();
      final response = await http.put(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Unable to connect to server', 0);
    }
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
    developer.log('token:$token');
    developer.log('Token: ${token != null ? "Available" : "Not available"}');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> deleteJson(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    developer.log('DELETE URL: $uri');
    try {
      final headers = await _headers();
      final response = await http.delete(uri, headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Unable to connect to server', 0);
    }
  }

  // NEW: Multipart POST method for image uploads
  Future<Map<String, dynamic>> postMultipart(
    String path,
    Map<String, dynamic> data,
    Map<String, File> files,
  ) async {
    try {
      final token = await getToken();
      final uri = Uri.parse('$baseUrl$path');

      developer.log('Multipart POST URL: $uri');
      developer.log('Form Data: $data');
      developer.log('Files to upload: ${files.keys.toList()}');

      var request = http.MultipartRequest('POST', uri);

      // Add authorization header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add form fields (text data)
      data.forEach((key, value) {
        if (value != null) {
          if (value is List || value is Map) {
            // Encode lists and maps as JSON strings
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Add files (images)
      for (var entry in files.entries) {
        final fieldName = entry.key;
        final file = entry.value;

        try {
          // Generate unique filename
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final randomId = _generateRandomId();
          final extension = file.path.split('.').last.toLowerCase();
          final filename = 'image-$timestamp-$randomId.$extension';

          developer.log('Adding file: $fieldName -> $filename');

          final multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            file.path,
            filename: filename,
          );
          request.files.add(multipartFile);
        } catch (e) {
          developer.log('Error adding file $fieldName: $e');
          throw ApiException('Failed to attach file: $fieldName', 0);
        }
      }

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      developer.log('Multipart response status: ${response.statusCode}');
      developer.log('Multipart response body: $responseBody');

      return _handleMultipartResponse(response.statusCode, responseBody);
    } on SocketException {
      throw ApiException('Unable to connect to server', 0);
    } catch (e) {
      developer.log('Multipart POST error: $e');
      rethrow;
    }
  }

  // Helper method to generate random ID for filenames
  String _generateRandomId() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isEmpty ? '{}' : response.body;
    developer.log('Response status: ${response.statusCode}');
    developer.log('Response body: $body');

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
            : 'Request failed with status ${response.statusCode}';
    throw ApiException(message, response.statusCode);
  }

  // Handle multipart response
  Map<String, dynamic> _handleMultipartResponse(int statusCode, String body) {
    developer.log('Multipart response status: $statusCode');
    developer.log('Multipart response body: $body');

    final decoded = body.isEmpty ? {} : jsonDecode(body);

    if (statusCode >= 200 && statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    final message =
        decoded is Map<String, dynamic> && decoded['message'] != null
            ? decoded['message'].toString()
            : 'Request failed with status $statusCode';
    throw ApiException(message, statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
