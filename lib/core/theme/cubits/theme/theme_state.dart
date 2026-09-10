import 'package:flutter/material.dart';

@immutable
abstract class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeInitialState extends ThemeState {
  const ThemeInitialState(super.themeMode);
}

class ChangeThemeState extends ThemeState {
  const ChangeThemeState(super.themeMode);
}
