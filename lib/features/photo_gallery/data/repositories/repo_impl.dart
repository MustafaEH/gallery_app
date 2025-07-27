import 'package:gallery/features/photo_gallery/data/data_source/pexels_api_service.dart';
import 'package:gallery/features/photo_gallery/data/models/api_response_model.dart';
import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';
import 'package:gallery/features/photo_gallery/data/services/cache_service.dart';

abstract class DataRepo {
  Future<ApiResponseModel> getCuratedPhotos({int? page, int? perPage});
}

class DataRepoImpl implements DataRepo {
  final PexelsApiService pexelsApiService;
  final CacheService cacheService;

  DataRepoImpl(this.pexelsApiService) : cacheService = CacheService();

  @override
  Future<ApiResponseModel> getCuratedPhotos({int? page, int? perPage}) async {
    try {
      // Try to fetch from API first
      final response = await pexelsApiService.getCuratedPhotos(
        page: page,
        perPage: perPage,
      );

      // If successful, cache the photos
      if (response.photos != null && response.photos!.isNotEmpty) {
        await cacheService.cachePhotos(response.photos!);
      }

      return response;
    } catch (e) {
      // If API fails, try to get cached data
      final cachedPhotos = await cacheService.getCachedPhotos();
      if (cachedPhotos.isNotEmpty) {
        // Return cached data in API response format
        return ApiResponseModel(
          page: page ?? 1,
          perPage: perPage ?? 20,
          photos: cachedPhotos,
          totalResults: cachedPhotos.length,
          nextPage: null,
          prevPage: null,
        );
      }

      // If no cached data, throw a user-friendly error
      if (e.toString().contains('No internet connection')) {
        throw Exception(
          'No internet connection and no cached photos available. Please connect to the internet and try again.',
        );
      } else if (e.toString().contains('timeout')) {
        throw Exception(
          'Request timed out and no cached photos available. Please check your connection and try again.',
        );
      } else if (e.toString().contains('Server error')) {
        throw Exception(
          'Server is unavailable and no cached photos available. Please try again later.',
        );
      } else {
        throw Exception(
          'Unable to load photos. Please check your internet connection and try again.',
        );
      }
    }
  }
}
