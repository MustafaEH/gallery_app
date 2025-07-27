import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:gallery/features/photo_gallery/data/models/api_response_model.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: "https://api.pexels.com/v1/")
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @GET("curated")
  Future<ApiResponseModel> getCuratedPhotos({
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  });
}
