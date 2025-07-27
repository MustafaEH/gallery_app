import 'package:dio/dio.dart';
import 'package:gallery/features/photo_gallery/data/data_source/api_services.dart';
import 'package:gallery/features/photo_gallery/data/models/api_response_model.dart';

class PexelsApiService {
  static const String _apiKey =
      'ZvLyemWcenWo4vuv1Py2jvdMYGrzNg9vAO6qawAT1Nvt2xcNHF2uAGJt';
  late final ApiServices _apiServices;

  PexelsApiService() {
    final dio = Dio();
    dio.options.headers['Authorization'] = _apiKey;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    _apiServices = ApiServices(dio);
  }

  Future<ApiResponseModel> getCuratedPhotos({int? page, int? perPage}) async {
    try {
      return await _apiServices.getCuratedPhotos(page: page, perPage: perPage);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
            'Request timeout. Please check your internet connection and try again.',
          );

        case DioExceptionType.connectionError:
          throw Exception(
            'No internet connection. Please check your network settings.',
          );

        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          switch (statusCode) {
            case 401:
              throw Exception('Authentication failed. Please try again later.');
            case 403:
              throw Exception('Access denied. Please try again later.');
            case 404:
              throw Exception('Photos not found. Please try again.');
            case 429:
              throw Exception(
                'Too many requests. Please wait a moment and try again.',
              );
            case 500:
              throw Exception(
                'Server error. Please try again in a few minutes.',
              );
            case 502:
              throw Exception('Bad gateway. Please try again later.');
            case 503:
              throw Exception(
                'Service temporarily unavailable. Please try again later.',
              );
            default:
              throw Exception(
                'Server error (${statusCode ?? 'unknown'}). Please try again.',
              );
          }

        case DioExceptionType.cancel:
          throw Exception('Request was cancelled.');

        case DioExceptionType.unknown:
        default:
          if (e.error.toString().contains('SocketException')) {
            throw Exception(
              'No internet connection. Please check your network and try again.',
            );
          }
          throw Exception(
            'Network error. Please check your connection and try again.',
          );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}
