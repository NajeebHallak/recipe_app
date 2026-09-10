import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @app_title.
  ///
  /// In ar, this message translates to:
  /// **'وصفاتي'**
  String get app_title;

  /// No description provided for @add_recipe.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وصفة'**
  String get add_recipe;

  /// No description provided for @edit_recipe.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الوصفة'**
  String get edit_recipe;

  /// No description provided for @delete_recipe.
  ///
  /// In ar, this message translates to:
  /// **'حذف وصفة'**
  String get delete_recipe;

  /// No description provided for @search_hint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن وصفة بالاسم أو المكونات...'**
  String get search_hint;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @main_meals.
  ///
  /// In ar, this message translates to:
  /// **'وجبات رئيسية'**
  String get main_meals;

  /// No description provided for @sweets.
  ///
  /// In ar, this message translates to:
  /// **'حلويات'**
  String get sweets;

  /// No description provided for @appetizers.
  ///
  /// In ar, this message translates to:
  /// **'مقبلات'**
  String get appetizers;

  /// No description provided for @drinks.
  ///
  /// In ar, this message translates to:
  /// **'مشروبات'**
  String get drinks;

  /// No description provided for @favorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get favorites;

  /// No description provided for @ingredients.
  ///
  /// In ar, this message translates to:
  /// **'المكونات'**
  String get ingredients;

  /// No description provided for @instructions.
  ///
  /// In ar, this message translates to:
  /// **'طريقة التحضير'**
  String get instructions;

  /// No description provided for @mins.
  ///
  /// In ar, this message translates to:
  /// **'دقيقة'**
  String get mins;

  /// No description provided for @persons.
  ///
  /// In ar, this message translates to:
  /// **'أشخاص'**
  String get persons;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete_confirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت تأكد من حذف هذه الوصفة؟'**
  String get delete_confirm;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'نجاح'**
  String get success;

  /// No description provided for @error_occurred.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، حدث خطأ'**
  String get error_occurred;

  /// No description provided for @delete_confirm_title.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحذف'**
  String get delete_confirm_title;

  /// No description provided for @prep_time.
  ///
  /// In ar, this message translates to:
  /// **'مدة التحضير'**
  String get prep_time;

  /// No description provided for @servings_count.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get servings_count;

  /// No description provided for @add_recipe_btn.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وصفة'**
  String get add_recipe_btn;

  /// No description provided for @title_ar_label.
  ///
  /// In ar, this message translates to:
  /// **'اسم الوصفة بالعربية'**
  String get title_ar_label;

  /// No description provided for @title_en_label.
  ///
  /// In ar, this message translates to:
  /// **'اسم الوصفة بالإنجليزية'**
  String get title_en_label;

  /// No description provided for @details_ar_label.
  ///
  /// In ar, this message translates to:
  /// **'وصف الوصفة بالعربية'**
  String get details_ar_label;

  /// No description provided for @details_en_label.
  ///
  /// In ar, this message translates to:
  /// **'وصف الوصفة بالإنجليزية'**
  String get details_en_label;

  /// No description provided for @prep_time_label.
  ///
  /// In ar, this message translates to:
  /// **'مدة التحضير (بالدقائق)'**
  String get prep_time_label;

  /// No description provided for @servings_label.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأشخاص'**
  String get servings_label;

  /// No description provided for @select_category.
  ///
  /// In ar, this message translates to:
  /// **'اختر التصنيف'**
  String get select_category;

  /// No description provided for @add_image.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة'**
  String get add_image;

  /// No description provided for @change_image.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الصورة'**
  String get change_image;

  /// No description provided for @field_required.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get field_required;

  /// No description provided for @invalid_number.
  ///
  /// In ar, this message translates to:
  /// **'يجب إدخال رقم صحيح'**
  String get invalid_number;

  /// No description provided for @number_must_be_greater_than_zero.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يكون الرقم أكبر من صفر'**
  String get number_must_be_greater_than_zero;

  /// No description provided for @empty_recipes.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد وصفات هنا!'**
  String get empty_recipes;

  /// No description provided for @no_image_available.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صورة'**
  String get no_image_available;

  /// No description provided for @image_required.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار صورة للوصفة'**
  String get image_required;

  /// No description provided for @recipe_added_success.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة الوصفة بنجاح!'**
  String get recipe_added_success;

  /// No description provided for @recipe_updated_success.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الوصفة بنجاح!'**
  String get recipe_updated_success;

  /// No description provided for @choose_image_source.
  ///
  /// In ar, this message translates to:
  /// **'اختر مصدر الصورة'**
  String get choose_image_source;

  /// No description provided for @gallery.
  ///
  /// In ar, this message translates to:
  /// **'المعرض'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get camera;

  /// No description provided for @image_pick_error.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء اختيار الصورة'**
  String get image_pick_error;

  /// No description provided for @smart_sync_center.
  ///
  /// In ar, this message translates to:
  /// **'مركز المزامنة الذكية'**
  String get smart_sync_center;

  /// No description provided for @pending_sync_operations.
  ///
  /// In ar, this message translates to:
  /// **'توجد {count} عمليات تنتظر اتصالك بالإنترنت'**
  String pending_sync_operations(int count);

  /// No description provided for @uploading_data.
  ///
  /// In ar, this message translates to:
  /// **'جاري رفع البيانات...'**
  String get uploading_data;

  /// No description provided for @start_sync_now.
  ///
  /// In ar, this message translates to:
  /// **'بدء المزامنة الآن'**
  String get start_sync_now;

  /// No description provided for @all_synced_up.
  ///
  /// In ar, this message translates to:
  /// **'كل شيء مزامن ومحدث!'**
  String get all_synced_up;

  /// No description provided for @waiting_to_upload.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار الرفع للسيرفر'**
  String get waiting_to_upload;

  /// No description provided for @preparing_to_update.
  ///
  /// In ar, this message translates to:
  /// **'جاري التجهيز للتحديث'**
  String get preparing_to_update;

  /// No description provided for @recipe_deleted_locally.
  ///
  /// In ar, this message translates to:
  /// **'الوصفة محذوفة محلياً ومؤقتاً'**
  String get recipe_deleted_locally;

  /// No description provided for @id_label.
  ///
  /// In ar, this message translates to:
  /// **'المعرف'**
  String get id_label;

  /// No description provided for @share_recipe_msg.
  ///
  /// In ar, this message translates to:
  /// **'جرب هذه الوصفة الرائعة!'**
  String get share_recipe_msg;

  /// No description provided for @print_recipe.
  ///
  /// In ar, this message translates to:
  /// **'طباعة الوصفة'**
  String get print_recipe;

  /// No description provided for @downloading_image.
  ///
  /// In ar, this message translates to:
  /// **'جاري تجهيز الصورة...'**
  String get downloading_image;

  /// No description provided for @notice_title.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه'**
  String get notice_title;

  /// No description provided for @empty_recipes_title.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد أية وصفات! 🍳'**
  String get empty_recipes_title;

  /// No description provided for @empty_recipes_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، لم نتمكن من العثور على أية وصفات تطابق بحثك. جرب كلمات مختلفة أو تصفح الأقسام الأخرى.'**
  String get empty_recipes_subtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
