import 'package:dartz/dartz.dart';
import 'package:recipe/core/errors/failure.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/data/models/recipe_request.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<RecipeModel>>> getRecipes();
  Future<Either<Failure, List<RecipeModel>>> refreshRecipes();
  Future<Either<Failure, Unit>> addRecipe(RecipeRequest request);
  Future<Either<Failure, Unit>> updateRecipe(RecipeRequest request);
  Future<Either<Failure, Unit>> toggleFavoriteLocal(RecipeModel recipe);
  Future<Either<Failure, Unit>> deleteRecipe(int id);
}
