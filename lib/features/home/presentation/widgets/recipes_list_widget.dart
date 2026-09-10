import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/router/app_page_name.dart';
import 'package:recipe/core/widgets/custom_delete_dialog.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/widgets/recipe_card_widget.dart';

class RecipesListWidget extends StatelessWidget {
  final List<RecipeModel> recipes;

  const RecipesListWidget({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // تعطيل السكرول
      shrinkWrap: true, // جعل القائمة تأخذ حجم عناصرها فقط
      padding: EdgeInsets.symmetric(horizontal: 16.rW, vertical: 8.rH),
      itemCount: recipes.length,
      separatorBuilder: (context, index) => AppGap.h16,
      itemBuilder: (context, index) {
        final recipe = recipes[index];

        return GestureDetector(
          onTap: () {
            context.push(AppPageName.recipeDetails, extra: recipe);
          },
          child: RecipeCardWidget(
            recipe: recipe,
            onEdit: () {
              context.push(AppPageName.addEditRecipe, extra: recipe);
            },
            onDelete: () {
              showDialog(
                context: context,
                builder: (ctx) => CustomDeleteDialog(
                  title: context.l10n.delete_confirm_title,
                  content: context.l10n.delete_confirm,
                  onConfirm: () {
                    BlocProvider.of<HomeCubit>(context).deleteRecipe(recipe.id);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
