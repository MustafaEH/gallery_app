import 'package:gallery/features/photo_gallery/data/repositories/repo_impl.dart';
import 'package:gallery/features/photo_gallery/presentation/cubit/photo_cubit.dart';
import 'package:gallery/core/theme/theme_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:gallery/features/photo_gallery/data/data_source/pexels_api_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Register Theme Provider
  getIt.registerLazySingleton<ThemeProvider>(() => ThemeProvider());

  // Register API Services
  getIt.registerLazySingleton<PexelsApiService>(() => PexelsApiService());

  // Register Repositories
  getIt.registerLazySingleton<DataRepo>(
    () => DataRepoImpl(getIt<PexelsApiService>()),
  );

  // Register Cubits
  getIt.registerFactory<PhotoCubit>(
    () => PhotoCubit(dataRepo: getIt<DataRepo>()),
  );
}
