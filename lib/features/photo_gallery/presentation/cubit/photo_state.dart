import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<PhotoModel> photos;
  final bool isLoadingMore;
  final bool isOfflineData; // New field to indicate if data is from cache

  PhotoLoaded(
    this.photos, {
    this.isLoadingMore = false,
    this.isOfflineData = false,
  });
}

class PhotoError extends PhotoState {
  final String message;
  final bool
  hasCachedData; // New field to indicate if there's cached data available

  PhotoError(this.message, {this.hasCachedData = false});
}
