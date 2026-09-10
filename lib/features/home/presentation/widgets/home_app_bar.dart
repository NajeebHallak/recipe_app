import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/localization/cubits/locale/locale_cubit.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/theme/cubits/theme/theme_cubit.dart';
import 'package:recipe/core/theme/cubits/theme/theme_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.l10n.app_title,
        style: TextStyle(fontSize: 20.rSp, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<LocaleCubit>(context).toggleLanguage();
          },
          icon: const Icon(Icons.language),
        ),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            bool isDark = state.themeMode == ThemeMode.dark;
            return IconButton(
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
