import 'package:gallery/features/photo_gallery/data/models/photo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

@JsonSerializable()
class ApiResponseModel {
  final int? page;
  @JsonKey(name: 'per_page')
  final int? perPage;
  @JsonKey(name: 'photos')
  final List<PhotoModel>? photos;
  @JsonKey(name: 'total_results')
  final int? totalResults;
  @JsonKey(name: 'next_page')
  final String? nextPage;
  @JsonKey(name: 'prev_page')
  final String? prevPage;

  ApiResponseModel({
    this.page,
    this.perPage,
    this.photos,
    this.totalResults,
    this.nextPage,
    this.prevPage,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);
}
