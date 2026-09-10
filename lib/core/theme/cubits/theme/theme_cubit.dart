import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/helpers/cache_helper.dart';
import 'package:recipe/core/util/consts.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitialState(ThemeMode.light)) {
    getSavedTheme();
  }

  void getSavedTheme() {
    final bool? isDark = CacheHelper.getData(key: Consts.themeKey);
    if (isDark != null) {
      emit(ChangeThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    }
  }

  Future<void> toggleTheme() async {
    final isCurrentlyDark = state.themeMode == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;

    emit(ChangeThemeState(newMode));
    await CacheHelper.saveData(key: Consts.themeKey, value: !isCurrentlyDark);
  }
}
