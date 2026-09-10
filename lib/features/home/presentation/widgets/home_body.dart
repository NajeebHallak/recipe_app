import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/util/snackbar_helper.dart';
import 'package:recipe/core/widgets/custom_error_widget.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart'
    show RecipeModel;
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_state.dart';
import 'package:recipe/features/home/presentation/widgets/recipes_success_widget.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          current is HomeGetRecipesError ||
          current is HomeDeleteRecipeSuccess ||
          current is HomeDeleteRecipeError,
      listener: (context, state) {
        if (state is HomeGetRecipesError) {
          SnackBarHelper.showError(context, message: state.message);
        } else if (state is HomeDeleteRecipeSuccess) {
          SnackBarHelper.showSuccess(context, message: 'تم حذف الوصفة بنجاح!');
        } else if (state is HomeDeleteRecipeError) {
          SnackBarHelper.showError(context, message: state.message);
        }
      },
      buildWhen: (previous, current) {
        // نحدث الواجهة فقط في حالات جلب البيانات لكي لا تختفي القائمة
        // عند حدوث حالات أخرى مثل تحميل الحذف أو التعديل
        return current is HomeGetRecipesLoading ||
            current is HomeGetRecipesSuccess ||
            current is HomeGetRecipesError;
      },
      builder: (context, state) {
        if (state is HomeGetRecipesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeGetRecipesError &&
            context.read<HomeCubit>().recipesList.isEmpty) {
          // نظهر شاشة الخطأ فقط إذا لم يكن هناك بيانات محلية سابقة
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<HomeCubit>().getRecipes();
            },
          );
        } else if (state is HomeGetRecipesSuccess) {
          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refreshRecipes(),
            child: RecipesSuccessWidget(recipes: state.recipes),
          );
        }

        // في حال تم إطلاق حالة أخرى، نظهر القائمة المخزنة في الكيوبت
        List<RecipeModel> recipes = context.read<HomeCubit>().recipesList;
        if (recipes.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refreshRecipes(),
            child: RecipesSuccessWidget(recipes: recipes),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
