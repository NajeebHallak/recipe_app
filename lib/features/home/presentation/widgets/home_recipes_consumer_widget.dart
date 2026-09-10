import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/util/snackbar_helper.dart';
import 'package:recipe/core/widgets/custom_error_widget.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_state.dart';
import 'package:recipe/features/home/presentation/widgets/empty_recipes_widget.dart';
import 'package:recipe/features/home/presentation/widgets/recipes_list_widget.dart';

class HomeRecipesConsumerWidget extends StatelessWidget {
  const HomeRecipesConsumerWidget({super.key});

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
            context.read<HomeCubit>().allRecipes.isEmpty) {
          // نظهر شاشة الخطأ فقط إذا لم يكن هناك بيانات محلية سابقة
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<HomeCubit>().getRecipes();
            },
          );
        } else if (state is HomeGetRecipesSuccess) {
          if (state.recipes.isEmpty) {
            return const EmptyRecipesWidget();
          }
          return RecipesListWidget(recipes: state.recipes);
        }

        // في حال تم إطلاق حالة أخرى، نظهر القائمة المخزنة في الكيوبت
        List<RecipeModel> recipes = context.read<HomeCubit>().displayedRecipes;
        if (recipes.isNotEmpty) {
          return RecipesListWidget(recipes: recipes);
        } else if (context.read<HomeCubit>().allRecipes.isNotEmpty) {
          // يوجد بيانات لكن تم تصفيتها (فلترتها) بالكامل
          return const EmptyRecipesWidget();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
