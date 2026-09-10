import 'package:go_router/go_router.dart';
import 'package:recipe/core/router/app_page_name.dart';
import 'package:recipe/features/home/presentation/screens/add_edit_recipe_screen.dart';
import 'package:recipe/features/home/presentation/screens/home_screen.dart';
import 'package:recipe/features/home/presentation/screens/recipe_details_screen.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart'
    as recipe_model;

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppPageName.home,
    routes: [
      GoRoute(
        path: AppPageName.home,
        builder: (context, state) => const HomeScrean(),
      ),
      GoRoute(
        path: AppPageName.recipeDetails,
        builder: (context, state) {
          final recipe = state.extra as recipe_model.RecipeModel?;
          return RecipeDetailsScreen(recipe: recipe);
        },
      ),
      GoRoute(
        path: AppPageName.addEditRecipe,
        builder: (context, state) {
          final recipe = state.extra as recipe_model.RecipeModel?;
          return AddEditRecipeScreen(recipe: recipe);
        },
      ),
    ],
  );
}
