import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/photo_tile.dart';

class PhotoGrid extends StatelessWidget {
  final List<PhotoModel> photos;

  const PhotoGrid({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: List.generate(photos.length, (index) {
        final photo = photos[index];
        final tileSize = _getTileSize(index);

        return PhotoTile(
          photo: photo,
          crossAxisCellCount: tileSize.cross,
          mainAxisCellCount: tileSize.main,
        );
      }),
    );
  }

  _TileSize _getTileSize(int index) {
    switch (index % 5) {
      case 0:
        return _TileSize(2, 2);
      case 1:
        return _TileSize(2, 1);
      case 2:
      case 3:
        return _TileSize(1, 1);
      default:
        return _TileSize(4, 2);
    }
  }
}

class _TileSize {
  final int cross;
  final int main;

  _TileSize(this.cross, this.main);
}
