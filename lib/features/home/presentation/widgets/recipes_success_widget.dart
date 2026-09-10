import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/presentation/widgets/home_search_bar.dart';
import 'package:recipe/features/home/presentation/widgets/home_categories_widget.dart';
import 'package:recipe/features/home/presentation/widgets/recipes_list_widget.dart';

class RecipesSuccessWidget extends StatefulWidget {
  final List<RecipeModel> recipes;

  const RecipesSuccessWidget({super.key, required this.recipes});

  @override
  State<RecipesSuccessWidget> createState() => _RecipesSuccessWidgetState();
}

class _RecipesSuccessWidgetState extends State<RecipesSuccessWidget> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    // نجلب الترجمة في دالة build
    final List<String> categories = [
      context.l10n.all,
      context.l10n.main_meals,
      context.l10n.sweets,
      context.l10n.appetizers,
      context.l10n.drinks,
      context.l10n.favorites,
    ];

    selectedCategory ??= context.l10n.all;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // شريط البحث
          const HomeSearchBar(),

          // شريط التصنيفات
          HomeCategoriesWidget(
            categories: categories,
            selectedCategory: selectedCategory!,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),

          AppGap.h16,

          // قائمة الوصفات
          RecipesListWidget(recipes: widget.recipes),
        ],
      ),
    );
  }
}
