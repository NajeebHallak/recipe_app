import 'package:flutter/material.dart';

@immutable
abstract class LocaleState {
  final Locale locale;
  const LocaleState(this.locale);
}

class LocaleInitialState extends LocaleState {
  const LocaleInitialState(super.locale);
}

class ChangeLocaleState extends LocaleState {
  const ChangeLocaleState(super.locale);
}
