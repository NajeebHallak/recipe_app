import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/theme/cubits/theme/theme_cubit.dart';
import 'package:recipe/core/theme/cubits/theme/theme_state.dart';

class BlocBuilderTheme extends StatelessWidget {
  const BlocBuilderTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return IconButton(
          onPressed: () {
            BlocProvider.of<ThemeCubit>(context).toggleTheme();
          },
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        );
      },
    );
  }
}
