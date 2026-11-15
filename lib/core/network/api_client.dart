import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'api_exceptions.dart';

/// ApiClient configures and wraps Dio for all network communications.
/// Includes strict timeout handling, authorization interceptors, and error transformations.
class ApiClient {
  final Dio dio;

  ApiClient({
    String baseUrl = ApiEndpoints.defaultParivahanBaseUrl,
    String? apiKey,
    String? bearerToken,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 15),
           sendTimeout: const Duration(seconds: 10),
           headers: {
             'Accept': 'application/json',
             'Content-Type': 'application/json',
             'User-Agent': 'RTO-Info/0.1.0 (Android; Linux)',
             if (apiKey != null) 'X-Api-Key': apiKey,
             if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
           },
         ),
       ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Future request logging / token refresh hooks
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final customException = _handleDioError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: customException,
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );
  }

  static ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NoInternetException();

      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) {
          return const VehicleNotFoundException(registrationNumber: '');
        }
        return ServerException(
          statusCode: code,
          message: error.response?.statusMessage ?? 'Server error occurred',
          details: error.response?.data,
        );

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled by user');

      default:
        return ApiException(
          message: error.message ?? 'An unexpected network error occurred',
        );
    }
  }

  /// Generic GET request
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
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Generic POST request
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
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
