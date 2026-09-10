import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'favorites_category_button.dart';
import 'category_item_widget.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // نجلب الترجمة في دالة build
    final List<String> categories = [
      context.l10n.all,
      context.l10n.main_meals,
      context.l10n.sweets,
      context.l10n.appetizers,
      context.l10n.drinks,
    ];

    // نستخدم watch بدلاً من BlocBuilder للحصول على كود أنظف بدون تداخل
    final cubit = context.watch<HomeCubit>();
    final currentCategory = cubit.currentCategory ?? context.l10n.all;

    return SizedBox(
      height: 45.rH,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        padding: EdgeInsets.symmetric(horizontal: 16.rW),
        itemBuilder: (context, index) {
          if (index == 0) {
            // زر المفضلة المنفصل
            return const FavoritesCategoryButton();
          }

          final String category = categories[index - 1];
          final bool isSelected = category == currentCategory;

          // الاقسام
          return CategoryItemWidget(
            category: category,
            isSelected: isSelected,
            onTap: () {
              // إذا كان الخيار هو "الكل" نرسل null للكيوبت
              if (category == context.l10n.all) {
                cubit.changeCategory(null);
              } else {
                cubit.changeCategory(category);
              }
            },
          );
        },
      ),
    );
  }
}
