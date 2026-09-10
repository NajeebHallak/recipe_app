import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recipe/core/errors/failure.dart';
import 'package:recipe/features/sync/data/data_sources/sync_local_data_source.dart';
import 'package:recipe/features/sync/data/data_sources/sync_remote_data_source.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/features/sync/domain/repositories/sync_repo.dart';

// نحتاج هذا لكي نقوم بحذف الوصفة الوهمية. في تطبيق أكبر، يتم التعامل معها بحدث (Event) أو Callback،
// أو حقن HomeLocalDataSource لمسح الوصفة الوهمية.
// لتنظيف العمارة، يفضل أن يأخذ SyncRepo حقن لـ HomeLocalDataSource أو نستخدم Callback
import 'package:recipe/features/home/data/data_sources/home_local_data_source.dart';

class SyncRepoImpl implements SyncRepo {
  final SyncLocalDataSource localDataSource;
  final SyncRemoteDataSource remoteDataSource;
  final HomeLocalDataSource homeLocalDataSource; // لحذف الوصفات الوهمية المؤقتة

  SyncRepoImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.homeLocalDataSource,
  });

  @override
  Future<void> queueRequest(SyncRequestModel request) async {
    await localDataSource.cacheSyncRequest(request);
  }

  @override
  Future<List<SyncRequestModel>> getPendingSyncRequests() async {
    return await localDataSource.getPendingSyncRequests();
  }

  @override
  Future<Either<Failure, Unit>> syncPendingRequests() async {
    try {
      List<SyncRequestModel> requests = await localDataSource
          .getPendingSyncRequests();

      if (requests.isEmpty) {
        return const Right(unit);
      }

      for (var req in requests) {
        await remoteDataSource.executeSyncRequest(req);

        // حذف الوصفة الوهمية المؤقتة من قاعدة البيانات المحلية في حال كانت POST
        if (req.method == 'POST' && req.recipeId != null) {
          await homeLocalDataSource.deleteRecipeLocal(req.recipeId!);
        }

        // مسح الطلب من الطابور بعد نجاحه
        await localDataSource.removeSyncRequest(req.id);
      }

      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
