import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// Dio-powered API Client maintaining compatibility with legacy methods
class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio() {
    _initDio();
  }

  void _initDio() {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: ApiConstants.connectionTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': ApiConstants.contentTypeJson,
        'Accept': ApiConstants.contentTypeJson,
      },
    );

    // Auth interceptor — attaches Bearer token to every request
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(ApiConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // 401 → pass through; AuthController watches for this and routes to login
        return handler.next(e);
      },
    ));

    // Logger (debug builds only)
    dio.interceptors.add(PrettyDioLogger(
      error: true,
      requestHeader: true,
      responseHeader: true,
      enabled: true,
      requestBody: true,
      responseBody: true,
    ));
  }


  /// REST GET Request (legacy compatible)
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool includeAuth = true,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          extra: {'includeAuth': includeAuth},
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  /// REST POST Request (legacy compatible)
  Future<ApiResponse> post(
    String endpoint, {
    dynamic body,
    bool includeAuth = true,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  /// REST PUT Request (legacy compatible)
  Future<ApiResponse> put(
    String endpoint, {
    dynamic body,
    bool includeAuth = true,
  }) async {
    try {
      final response = await dio.put(
        endpoint,
        data: body,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  /// REST PATCH Request (legacy compatible)
  Future<ApiResponse> patch(
    String endpoint, {
    dynamic body,
    bool includeAuth = true,
  }) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: body,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  /// REST DELETE Request (legacy compatible)
  Future<ApiResponse> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final response = await dio.delete(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  /// Multi-file Upload (for complaints: up to 5 images)
  Future<ApiResponse> uploadFiles(
    String endpoint,
    List<File> files, {
    String fieldName = 'images',
    Map<String, String>? additionalFields,
  }) async {
    try {
      final formMap = <String, dynamic>{};

      // Add each file under the same field name (array)
      final fileList = <MultipartFile>[];
      for (final file in files) {
        fileList.add(await MultipartFile.fromFile(file.path));
      }
      formMap[fieldName] = fileList;

      if (additionalFields != null) {
        formMap.addAll(additionalFields);
      }

      final formData = FormData.fromMap(formMap);
      final response = await dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }


  /// Handle Dio Response -> Legacy ApiResponse
  ApiResponse _handleResponse(Response response) {
    return ApiResponse(
      success:
          (response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300,
      data: response.data,
      statusCode: response.statusCode,
      message: response.statusMessage,
    );
  }

  /// Handle Dio Error -> Legacy ApiResponse
  ApiResponse _handleDioError(DioException error) {
    final response = error.response;
    return ApiResponse(
      success: false,
      data: response?.data,
      statusCode: response?.statusCode,
      message: error.message ?? 'Unknown error',
    );
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.tokenKey);
  }

  void close() {
    dio.close();
  }
}

/// Legacy API Response Model for app compatibility
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

/// Generic wrapper for Retrofit calls (not strictly required by old services)
class ApiResponseWrapper<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponseWrapper({
    this.success = true,
    this.data,
    this.message,
  });
}
