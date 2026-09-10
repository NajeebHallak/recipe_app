import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';

class FavoritesCategoryButton extends StatelessWidget {
  const FavoritesCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم watch للحصول على التحديثات بدون تعقيد BlocBuilder
    final cubit = context.watch<HomeCubit>();
    final isSelected = cubit.showOnlyFavorites;

    return GestureDetector(
      onTap: () {
        cubit.toggleFavoritesView();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(left: 8.rW, bottom: 4.rH),
        padding: EdgeInsets.symmetric(horizontal: 20.rW),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.rW),
          border: Border.all(color: Colors.red, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.favorite : Icons.favorite_border,
                color: isSelected ? Colors.white : Colors.red,
                size: 16.rSp,
              ),
              AppGap.w4,
              Text(
                context.l10n.favorites,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.red,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13.rSp,
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
