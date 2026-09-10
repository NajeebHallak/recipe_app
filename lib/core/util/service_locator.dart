import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe/core/services/api_service.dart';
import 'package:recipe/features/home/data/data_sources/home_local_data_source.dart';
import 'package:recipe/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:recipe/features/home/data/repositories/home_repo_impl.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/sync/data/data_sources/sync_local_data_source.dart';
import 'package:recipe/features/sync/data/data_sources/sync_remote_data_source.dart';
import 'package:recipe/features/sync/data/repositories/sync_repo_impl.dart';
import 'package:recipe/features/sync/domain/repositories/sync_repo.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_cubit.dart';
import 'package:recipe/core/theme/cubits/theme/theme_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  // Data Sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<SyncRemoteDataSource>(
    () => SyncRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SyncLocalDataSource>(
    () => SyncLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<SyncRepo>(
    () => SyncRepoImpl(
      remoteDataSource: getIt<SyncRemoteDataSource>(),
      localDataSource: getIt<SyncLocalDataSource>(),
      homeLocalDataSource: getIt<HomeLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<HomeRepoImpl>(
    () => HomeRepoImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      localDataSource: getIt<HomeLocalDataSource>(),
      syncRepo: getIt<SyncRepo>(),
    ),
  );

  // Cubits
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepoImpl>()));
  getIt.registerFactory<SyncCubit>(() => SyncCubit(getIt<SyncRepo>()));
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());
}
