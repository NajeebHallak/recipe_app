import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/widgets/home_categories_widget.dart';
import 'package:recipe/features/home/presentation/widgets/home_recipes_consumer_widget.dart';
import 'package:recipe/features/home/presentation/widgets/home_search_bar.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().refreshRecipes(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // شريط البحث
            const HomeSearchBar(),

            // شريط التصنيفات
            HomeCategoriesWidget(),

            AppGap.h16,
            //الوصفات
            HomeRecipesConsumerWidget(),
          ],
        ),
      ),
    );
  }
}
