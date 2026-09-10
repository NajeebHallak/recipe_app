import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/util/snackbar_helper.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_state.dart';
import 'package:recipe/features/home/presentation/widgets/recipe_form_widget.dart';

class AddEditRecipeScreen extends StatelessWidget {
  final RecipeModel? recipe;

  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeAddRecipeSuccess) {
          SnackBarHelper.showSuccess(
            context,
            message: context.l10n.recipe_added_success,
          );
          context.pop();
        } else if (state is HomeUpdateRecipeSuccess) {
          SnackBarHelper.showSuccess(
            context,
            message: context.l10n.recipe_updated_success,
          );
          context.pop();
        } else if (state is HomeAddRecipeError) {
          SnackBarHelper.showError(context, message: state.message);
        } else if (state is HomeUpdateRecipeError) {
          SnackBarHelper.showError(context, message: state.message);
          print("${state.message}");
        }
      },
      child: RecipeFormWidget(recipe: recipe),
    );
  }
}
