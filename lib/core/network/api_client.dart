import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// HTTP Client for API calls
class ApiClient {
  final HttpClient _httpClient;
  String? _authToken;

  ApiClient() : _httpClient = HttpClient() {
    _httpClient.connectionTimeout = ApiConstants.connectionTimeout;
    _loadToken();
  }

  /// Load auth token from storage
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(ApiConstants.tokenKey);
  }

  /// Set auth token
  Future<void> setToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.tokenKey, token);
  }

  /// Clear auth token
  Future<void> clearToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.tokenKey);
  }

  /// Get auth token
  String? get token => _authToken;

  /// Build full URL
  String _buildUrl(String endpoint) {
    return '${ApiConstants.apiBaseUrl}$endpoint';
  }

  /// Add common headers
  Map<String, String> _buildHeaders({
    Map<String, String>? additionalHeaders,
    bool includeAuth = true,
  }) {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ApiConstants.contentTypeJson,
      HttpHeaders.acceptHeader: ApiConstants.contentTypeJson,
    };

    if (includeAuth && _authToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// GET Request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool includeAuth = true,
  }) async {
    try {
      var url = _buildUrl(endpoint);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        final queryString = queryParameters.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        url = '$url?$queryString';
      }

      final uri = Uri.parse(url);
      final request = await _httpClient.getUrl(uri);

      // Add headers
      final headers = _buildHeaders(includeAuth: includeAuth);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// POST Request
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final uri = Uri.parse(url);
      final request = await _httpClient.postUrl(uri);

      // Add headers
      final headers = _buildHeaders(includeAuth: includeAuth);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      // Add body
      if (body != null) {
        final jsonBody = jsonEncode(body);
        print('📤 Request Body ($endpoint): $jsonBody');
        request.write(jsonBody);
      }

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// PUT Request
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final uri = Uri.parse(url);
      final request = await _httpClient.putUrl(uri);

      // Add headers
      final headers = _buildHeaders(includeAuth: includeAuth);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      // Add body
      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
  /// PATCH Request
  Future<ApiResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final uri = Uri.parse(url);
      final request = await _httpClient.patchUrl(uri);

      // Add headers
      final headers = _buildHeaders(includeAuth: includeAuth);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      // Add body
      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// DELETE Request
  Future<ApiResponse> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final uri = Uri.parse(url);
      final request = await _httpClient.deleteUrl(uri);

      // Add headers
      final headers = _buildHeaders(includeAuth: includeAuth);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Handle HTTP Response
  Future<ApiResponse> _handleResponse(HttpClientResponse response) async {
    final responseBody = await response.transform(utf8.decoder).join();
    final statusCode = response.statusCode;

    try {
      final jsonData = jsonDecode(responseBody);

      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse(
          success: true,
          data: jsonData,
          statusCode: statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'Request failed',
          statusCode: statusCode,
          data: jsonData,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to parse response: ${e.toString()}',
        statusCode: statusCode,
      );
    }
  }

  /// Upload file with multipart
  Future<ApiResponse> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
    Map<String, String>? additionalFields,
    bool includeAuth = true,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final uri = Uri.parse(url);
      final request = await _httpClient.postUrl(uri);

      // Set multipart boundary
      final boundary = '----WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}';
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );

      if (includeAuth && _authToken != null) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $_authToken',
        );
      }

      // Build multipart body
      final fileBytes = await file.readAsBytes();
      final fileName = file.path.split('/').last;

      final multipartBody = StringBuffer();

      // Add additional fields
      if (additionalFields != null) {
        additionalFields.forEach((key, value) {
          multipartBody.write('--$boundary\r\n');
          multipartBody.write('Content-Disposition: form-data; name="$key"\r\n\r\n');
          multipartBody.write('$value\r\n');
        });
      }

      // Add file
      multipartBody.write('--$boundary\r\n');
      multipartBody.write(
        'Content-Disposition: form-data; name="$fieldName"; filename="$fileName"\r\n',
      );
      multipartBody.write('Content-Type: application/octet-stream\r\n\r\n');

      request.write(multipartBody.toString());
      request.add(fileBytes);
      request.write('\r\n--$boundary--\r\n');

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'File upload error: ${e.toString()}',
      );
    }
  }

  /// Close the client
  void close() {
    _httpClient.close();
  }
}

/// API Response Model
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
  }
}
