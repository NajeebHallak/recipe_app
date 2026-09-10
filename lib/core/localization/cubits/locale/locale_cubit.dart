import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/helpers/cache_helper.dart';
import 'package:recipe/core/util/consts.dart';

import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleInitialState(Locale('ar'))) {
    getSavedLanguage();
  }

  void getSavedLanguage() {
    final String? langCode = CacheHelper.getData(key: Consts.langKey);
    if (langCode != null) {
      emit(ChangeLocaleState(Locale(langCode)));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state.locale.languageCode == languageCode) return;

    final newLocale = Locale(languageCode);
    emit(ChangeLocaleState(newLocale));
    await CacheHelper.saveData(key: Consts.langKey, value: languageCode);
  }

  void toggleLanguage() {
    final nextLang = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    changeLanguage(nextLang);
  }
}
