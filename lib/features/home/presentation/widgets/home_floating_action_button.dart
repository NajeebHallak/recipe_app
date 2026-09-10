import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/router/app_page_name.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        borderRadius: AppRadius.kRadiusLarge16,
      ),
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.kRadiusLarge16),
        onPressed: () async {
          // نذهب لصفحة الإضافة، وعند العودة نطلب جلب البيانات مجدداً
          await GoRouter.of(context).push(AppPageName.addEditRecipe);
          if (context.mounted) {
            context.read<HomeCubit>().getRecipes();
          }
        },
        // icon: Icon(Icons.add_circle_outline_rounded, size: 24.rSp),
        label: Text(
          context.l10n.add_recipe,
          style: TextStyle(
            fontSize: 16.rSp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
