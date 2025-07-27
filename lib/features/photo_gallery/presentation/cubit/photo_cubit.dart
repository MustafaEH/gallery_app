import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';
import 'package:gallery/features/photo_gallery/data/repositories/repo_impl.dart';
import 'package:gallery/features/photo_gallery/data/services/cache_service.dart';
import 'package:gallery/features/photo_gallery/presentation/cubit/photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final DataRepo dataRepo;
  final CacheService cacheService;
  int currentPage = 1;
  List<PhotoModel> allPhotos = [];
  bool hasReachedMax = false;
  bool isOfflineMode = false;

  PhotoCubit({required this.dataRepo})
    : cacheService = CacheService(),
      super(PhotoInitial());

  Future<void> loadPhotos() async {
    if (hasReachedMax && !isOfflineMode) return;

    emit(PhotoLoading());
    await _fetchPhotos(isInitialLoad: true);
  }

  Future<void> loadMorePhotos() async {
    if (hasReachedMax && !isOfflineMode) return;

    if (state is PhotoLoaded) {
      final currentState = state as PhotoLoaded;
      emit(
        PhotoLoaded(
          allPhotos,
          isLoadingMore: true,
          isOfflineData: currentState.isOfflineData,
        ),
      );
    }
    await _fetchPhotos(isInitialLoad: false);
  }

  Future<void> _fetchPhotos({required bool isInitialLoad}) async {
    try {
      final response = await dataRepo.getCuratedPhotos(
        page: currentPage,
        perPage: 20,
      );

      if (response.photos != null && response.photos!.isNotEmpty) {
        // Check if this is cached data (no next_page indicates cached data)
        final isCachedData = response.nextPage == null;

        if (isInitialLoad) {
          allPhotos = response.photos!;
          currentPage = 1;
          isOfflineMode = isCachedData;
        } else {
          allPhotos.addAll(response.photos!);
          currentPage++;
        }

        if (response.photos!.length < 20) {
          hasReachedMax = true;
        }

        emit(
          PhotoLoaded(
            allPhotos,
            isLoadingMore: false,
            isOfflineData: isCachedData,
          ),
        );
      } else {
        hasReachedMax = true;
        emit(
          PhotoLoaded(
            allPhotos,
            isLoadingMore: false,
            isOfflineData: isOfflineMode,
          ),
        );
      }
    } catch (e) {
      // Check if we have cached data available
      final cachedPhotos = await cacheService.getCachedPhotos();
      if (cachedPhotos.isNotEmpty) {
        allPhotos = cachedPhotos;
        isOfflineMode = true;
        emit(PhotoLoaded(allPhotos, isOfflineData: true));
      } else {
        emit(PhotoError(e.toString(), hasCachedData: false));
      }
    }
  }
}
