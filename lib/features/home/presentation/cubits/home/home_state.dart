import 'package:recipe/features/home/data/models/recipe_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

// ----------------- Get Recipes States -----------------
class HomeGetRecipesLoading extends HomeState {}

class HomeGetRecipesSuccess extends HomeState {
  final List<RecipeModel> recipes;
  HomeGetRecipesSuccess(this.recipes);
}

class HomeGetRecipesError extends HomeState {
  final String message;
  HomeGetRecipesError(this.message);
}

// ----------------- Add Recipe States -----------------
class HomeAddRecipeLoading extends HomeState {}

class HomeAddRecipeSuccess extends HomeState {}

class HomeAddRecipeError extends HomeState {
  final String message;
  HomeAddRecipeError(this.message);
}

// ----------------- Update Recipe States -----------------
class HomeUpdateRecipeLoading extends HomeState {}

class HomeUpdateRecipeSuccess extends HomeState {}

class HomeUpdateRecipeError extends HomeState {
  final String message;
  HomeUpdateRecipeError(this.message);
}

// ----------------- Delete Recipe States -----------------
class HomeDeleteRecipeLoading extends HomeState {}

class HomeDeleteRecipeSuccess extends HomeState {}

class HomeDeleteRecipeError extends HomeState {
  final String message;
  HomeDeleteRecipeError(this.message);
}
