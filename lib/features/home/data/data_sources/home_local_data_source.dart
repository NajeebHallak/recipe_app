import 'package:objectbox/objectbox.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/main.dart'; // For objectBox

abstract class HomeLocalDataSource {
  Future<List<RecipeModel>> getRecipes();
  Future<void> cacheRecipes(List<RecipeModel> recipes);
  Future<int> addRecipeLocal(RecipeModel recipe);
  Future<void> updateRecipeLocal(RecipeModel recipe);
  Future<void> deleteRecipeLocal(int id);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Box<RecipeModel> _recipeBox = objectBox.store.box<RecipeModel>();

  @override
  Future<List<RecipeModel>> getRecipes() async {
    return _recipeBox.getAll();
  }

  @override
  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    List<RecipeModel> oldRecipes = _recipeBox.getAll();
    final Map<int, bool> favoriteMap = {};
    for (var r in oldRecipes) {
      if (r.isFavorite) {
        favoriteMap[r.id] = true;
      }
    }

    for (var r in recipes) {
      if (favoriteMap.containsKey(r.id)) {
        r.isFavorite = true;
      }
    }

    _recipeBox.removeAll();
    _recipeBox.putMany(recipes);
  }

  @override
  Future<int> addRecipeLocal(RecipeModel recipe) async {
    return _recipeBox.put(recipe);
  }

  @override
  Future<void> updateRecipeLocal(RecipeModel recipe) async {
    _recipeBox.put(recipe);
  }

  @override
  Future<void> deleteRecipeLocal(int id) async {
    _recipeBox.remove(id);
  }
}
