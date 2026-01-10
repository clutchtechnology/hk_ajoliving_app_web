import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';

/// API 客户端配置
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  
  factory ApiClient() {
    return _instance;
  }
  
  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // 添加拦截器
    dio.interceptors.add(_ApiInterceptor());
  }
  
  /// GET 请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST 请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT 请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE 请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 设置认证 Token
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  /// 清除认证 Token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
  
  /// 错误处理
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('连接超时，请检查网络设置');
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return ApiException('请求已取消');
      default:
        return ApiException('网络错误，请稍后重试');
    }
  }
  
  /// 处理响应错误
  Exception _handleResponseError(Response? response) {
    if (response == null) {
      return ApiException('服务器无响应');
    }
    
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    
    String message = '请求失败';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'] as String;
    }
    
    switch (statusCode) {
      case 400:
        return ApiException(message);
      case 401:
        return ApiException('未授权，请先登录');
      case 403:
        return ApiException('无权限访问');
      case 404:
        return ApiException('资源未找到');
      case 500:
        return ApiException('服务器错误');
      default:
        return ApiException(message);
    }
  }
}

/// API 拦截器
class _ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 可以在这里添加日志、Token 等
    print('API Request: ${options.method} ${options.path}');
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('API Response: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('API Error: ${err.message}');
    handler.next(err);
  }
}

/// API 异常类
class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => message;
}
