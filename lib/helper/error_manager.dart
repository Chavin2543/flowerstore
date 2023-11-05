import 'package:dio/dio.dart';
import 'package:flowerstore/data/api_error.dart';

class ErrorManager {
  static APIError handleAPIError(dynamic error) {
    if (error is DioException) {
      print(error);
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return APIError('Connection timed out. Please check your internet connection.');
      } else if (error.type == DioExceptionType.badResponse) {
        return APIError('Server returned an error: ${error.response?.statusCode} - ${error.response?.statusMessage}');
      } else if (error.type == DioExceptionType.cancel) {
        return APIError('Request was cancelled.');
      } else if (error.type == DioExceptionType.unknown) {
        return APIError(error.message ?? "Unknown Error");
      }
    }
    return APIError('An unknown error occurred.');
  }
}