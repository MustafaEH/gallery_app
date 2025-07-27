import 'package:flutter/material.dart';
import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/offline_banner.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/photo_grid.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/load_more_button.dart';

class PhotoContent extends StatelessWidget {
  final List<PhotoModel> photos;
  final bool isLoadingMore;
  final bool isOfflineData;

  const PhotoContent({
    super.key,
    required this.photos,
    required this.isLoadingMore,
    required this.isOfflineData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Offline indicator
          if (isOfflineData) const OfflineBanner(),

          // Photo grid
          PhotoGrid(photos: photos),

          const SizedBox(height: 20),

          // Show More button (only if not in offline mode)
          if (!isOfflineData) LoadMoreButton(isLoadingMore: isLoadingMore),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
