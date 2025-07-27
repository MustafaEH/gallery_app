import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';

class CacheService {
  static const String _photosKey = 'cached_photos';
  static const String _lastFetchTimeKey = 'last_fetch_time';
  static const String _cacheExpiryKey = 'cache_expiry_hours';

  // Cache expires after 24 hours by default
  static const int _defaultExpiryHours = 24;

  // Save photos to cache
  Future<void> cachePhotos(List<PhotoModel> photos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photosJson = photos.map((photo) => photo.toJson()).toList();

      await prefs.setString(_photosKey, jsonEncode(photosJson));
      await prefs.setInt(
        _lastFetchTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Log error silently in production
    }
  }

  // Get cached photos
  Future<List<PhotoModel>> getCachedPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photosJson = prefs.getString(_photosKey);

      if (photosJson != null) {
        final List<dynamic> decoded = jsonDecode(photosJson);
        return decoded.map((json) => PhotoModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Log error silently in production
    }
    return [];
  }

  // Check if cache is valid (not expired)
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastFetchTime = prefs.getInt(_lastFetchTimeKey);

      if (lastFetchTime == null) return false;

      final lastFetch = DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
      final now = DateTime.now();
      final difference = now.difference(lastFetch);

      final expiryHours = prefs.getInt(_cacheExpiryKey) ?? _defaultExpiryHours;

      return difference.inHours < expiryHours;
    } catch (e) {
      return false;
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_photosKey);
      await prefs.remove(_lastFetchTimeKey);
    } catch (e) {
      // Log error silently in production
    }
  }

  // Set cache expiry time
  Future<void> setCacheExpiry(int hours) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_cacheExpiryKey, hours);
    } catch (e) {
      // Log error silently in production
    }
  }

  // Get cache info
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastFetchTime = prefs.getInt(_lastFetchTimeKey);
      final photosJson = prefs.getString(_photosKey);

      if (lastFetchTime != null && photosJson != null) {
        final lastFetch = DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
        final photos = jsonDecode(photosJson) as List;

        return {
          'lastFetch': lastFetch,
          'photoCount': photos.length,
          'isValid': await isCacheValid(),
        };
      }
    } catch (e) {
      // Log error silently in production
    }

    return {'lastFetch': null, 'photoCount': 0, 'isValid': false};
  }
}
