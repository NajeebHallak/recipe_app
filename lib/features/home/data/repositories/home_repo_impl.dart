import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recipe/core/errors/failure.dart';

import 'package:recipe/features/home/data/data_sources/home_local_data_source.dart';
import 'package:recipe/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/data/models/recipe_request.dart';
import 'package:recipe/features/home/domain/repositories/home_repo.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/features/sync/domain/repositories/sync_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final SyncRepo syncRepo;

  HomeRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.syncRepo,
  });

  @override
  Future<Either<Failure, List<RecipeModel>>> getRecipes() async {
    try {
      // جلب البيانات من اللوكال أولاً (ObjectBox)
      List<RecipeModel> localRecipes = await localDataSource.getRecipes();

      if (localRecipes.isNotEmpty) {
        // إذا كان هناك بيانات محلية، نعرضها فوراً
        return Right(localRecipes);
      } else {
        // إذا كان اللوكال فارغاً، نجلب من السيرفر كبديل
        return await refreshRecipes();
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeModel>>> refreshRecipes() async {
    try {
      // نجلب من السيرفر (Remote)
      List<RecipeModel> remoteRecipes = await remoteDataSource.getRecipes();

      // نقوم بتخزين الوصفات القادمة من السيرفر في اللوكال داتا سورس (الكاش)
      await localDataSource.cacheRecipes(remoteRecipes);

      return Right(remoteRecipes);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  bool _isOfflineError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type ==
            DioExceptionType.unknown; // unknown often masks SocketException
  }

  @override
  Future<Either<Failure, Unit>> addRecipe(RecipeRequest request) async {
    try {
      await remoteDataSource.addRecipe(request);
      return const Right(unit);
    } catch (e) {
      if (e is DioException && _isOfflineError(e)) {
        // 1. التحديث المتفائل (Optimistic Update) في قاعدة البيانات المحلية
        RecipeModel recipe = RecipeModel(
          id: 0,
          titleAr: request.titleAr,
          titleEn: request.titleEn,
          detailsAr: request.detailsAr ?? '',
          detailsEn: request.detailsEn ?? '',
          imageUrl: request.imagePath != null ? [request.imagePath!] : [],
          createdAt: DateTime.now().toIso8601String(),
          prepTime: 0,
          servings: 0,
          category: request.category,
        );
        // استرجاع الـ ID المؤقت من قاعدة البيانات المحلية
        int tempId = await localDataSource.addRecipeLocal(recipe);

        // 2. حفظ الطلب في طابور الأوفلاين وربطه بالـ ID المؤقت
        SyncRequestModel syncReq = SyncRequestModel(
          method: 'POST',
          endpoint: '/recipes',
          payloadJson: request.toJson(),
          imagePath: request.imagePath,
          recipeId: tempId, // ربط الطلب بالوصفة الوهمية
        );
        await syncRepo.queueRequest(syncReq);

        return const Right(unit);
      } else if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRecipe(RecipeRequest request) async {
    try {
      await remoteDataSource.updateRecipe(request);
      return const Right(unit);
    } catch (e) {
      if (e is DioException && _isOfflineError(e)) {
        // حفظ الطلب في طابور الأوفلاين
        SyncRequestModel syncReq = SyncRequestModel(
          method: 'PUT',
          endpoint: '/recipes/${request.id}',
          payloadJson: request.toJson(),
          imagePath: request.imagePath,
          recipeId: request.id,
        );
        await syncRepo.queueRequest(syncReq);

        // التحديث المتفائل (Optimistic Update)
        List<RecipeModel> recipes = await localDataSource.getRecipes();
        int existingRecipeIndex = recipes.indexWhere((r) => r.id == request.id);
        if (existingRecipeIndex != -1) {
          RecipeModel recipe = recipes[existingRecipeIndex];
          recipe.titleAr = request.titleAr;
          recipe.titleEn = request.titleEn;
          if (request.detailsAr != null) recipe.detailsAr = request.detailsAr!;
          if (request.detailsEn != null) recipe.detailsEn = request.detailsEn!;
          recipe.category = request.category;
          if (request.imagePath != null) recipe.imageUrl = [request.imagePath!];

          await localDataSource.updateRecipeLocal(recipe);
        }
        return const Right(unit);
      } else if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRecipe(int id) async {
    try {
      await remoteDataSource.deleteRecipe(id);
      return const Right(unit);
    } catch (e) {
      if (e is DioException && _isOfflineError(e)) {
        // إضافة الطلب إلى الطابور للمزامنة لاحقاً
        SyncRequestModel syncReq = SyncRequestModel(
          method: 'DELETE',
          endpoint: '/recipes/$id',
          recipeId: id,
        );
        await syncRepo.queueRequest(syncReq);

        // حذف محلي متفائل
        await localDataSource.deleteRecipeLocal(id);
        return const Right(unit);
      } else if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
