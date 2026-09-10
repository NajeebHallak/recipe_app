import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/helpers/cache_helper.dart';
import 'package:recipe/core/helpers/object_box_helper.dart';
import 'package:recipe/core/localization/cubits/locale/locale_cubit.dart';
import 'package:recipe/core/localization/cubits/locale/locale_state.dart';
import 'package:recipe/core/localization/l10n/app_localizations.dart';
import 'package:recipe/core/theme/cubits/theme/theme_cubit.dart';
import 'package:recipe/core/theme/cubits/theme/theme_state.dart';
import 'package:recipe/core/router/app_router.dart';
import 'package:recipe/core/util/service_locator.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_cubit.dart';

import 'core/theme/app_theme.dart';

late ObjectBoxHelper objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة حقن التبعيات (DI)
  setupServiceLocator();

  // تهيئة SharedPreferences قبل تشغيل التطبيق
  await CacheHelper.init();

  // تهيئة ObjectBox
  objectBox = await ObjectBoxHelper.create();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => getIt<HomeCubit>()..getRecipes()),
        BlocProvider(create: (context) => getIt<SyncCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              title: 'وصفاتي',
              debugShowCheckedModeBanner: false,

              // تهيئة الأبعاد
              builder: (context, child) {
                AppResponsive.init(baseWidth: 375, baseHeight: 812);
                return child!;
              },

              // إعدادات الراوتر (GoRouter)
              routerConfig: AppRouter.router,

              // 1️⃣ إعدادات الثيم
              themeMode: themeState.themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,

              // 2️⃣ إعدادات l10n الرسمية
              locale: localeState.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
            );
          },
        );
      },
    );
  }
}
