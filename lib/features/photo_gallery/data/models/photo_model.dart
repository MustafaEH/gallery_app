import 'package:json_annotation/json_annotation.dart';

part 'photo_model.g.dart';

@JsonSerializable()
class PhotoModel {
  final int? id;
  final int? width;
  final int? height;
  final String? photographer;
  @JsonKey(name: 'alt')
  final String? description;
  @JsonKey(name: 'src')
  final Map<String, dynamic>? src;

  PhotoModel({
    this.id,
    this.width,
    this.height,
    this.photographer,
    this.description,
    this.src,
  });

  String? get imageUrl => src?['medium'];

  double? get aspectRatio {
    if (width != null && height != null && height! > 0) {
      return width! / height!;
    }
    return null;
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);
}
