// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_title => 'وصفاتي';

  @override
  String get add_recipe => 'إضافة وصفة';

  @override
  String get edit_recipe => 'تعديل الوصفة';

  @override
  String get delete_recipe => 'حذف وصفة';

  @override
  String get search_hint => 'ابحث عن وصفة بالاسم أو المكونات...';

  @override
  String get all => 'الكل';

  @override
  String get main_meals => 'وجبات رئيسية';

  @override
  String get sweets => 'حلويات';

  @override
  String get appetizers => 'مقبلات';

  @override
  String get drinks => 'مشروبات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get ingredients => 'المكونات';

  @override
  String get instructions => 'طريقة التحضير';

  @override
  String get mins => 'دقيقة';

  @override
  String get persons => 'أشخاص';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete_confirm => 'هل أنت تأكد من حذف هذه الوصفة؟';

  @override
  String get success => 'نجاح';

  @override
  String get error_occurred => 'عذراً، حدث خطأ';

  @override
  String get delete_confirm_title => 'تأكيد الحذف';

  @override
  String get prep_time => 'مدة التحضير';

  @override
  String get servings_count => 'الكمية';

  @override
  String get add_recipe_btn => 'إضافة وصفة';

  @override
  String get title_ar_label => 'اسم الوصفة بالعربية';

  @override
  String get title_en_label => 'اسم الوصفة بالإنجليزية';

  @override
  String get details_ar_label => 'وصف الوصفة بالعربية';

  @override
  String get details_en_label => 'وصف الوصفة بالإنجليزية';

  @override
  String get prep_time_label => 'مدة التحضير (بالدقائق)';

  @override
  String get servings_label => 'عدد الأشخاص';

  @override
  String get select_category => 'اختر التصنيف';

  @override
  String get add_image => 'إضافة صورة';

  @override
  String get change_image => 'تغيير الصورة';

  @override
  String get field_required => 'هذا الحقل مطلوب';

  @override
  String get invalid_number => 'يجب إدخال رقم صحيح';

  @override
  String get number_must_be_greater_than_zero =>
      'يجب أن يكون الرقم أكبر من صفر';

  @override
  String get empty_recipes => 'لا توجد وصفات هنا!';

  @override
  String get no_image_available => 'لا توجد صورة';

  @override
  String get image_required => 'الرجاء اختيار صورة للوصفة';

  @override
  String get recipe_added_success => 'تم إضافة الوصفة بنجاح!';

  @override
  String get recipe_updated_success => 'تم تعديل الوصفة بنجاح!';

  @override
  String get choose_image_source => 'اختر مصدر الصورة';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get image_pick_error => 'حدث خطأ أثناء اختيار الصورة';

  @override
  String get smart_sync_center => 'مركز المزامنة الذكية';

  @override
  String pending_sync_operations(int count) {
    return 'توجد $count عمليات تنتظر اتصالك بالإنترنت';
  }

  @override
  String get uploading_data => 'جاري رفع البيانات...';

  @override
  String get start_sync_now => 'بدء المزامنة الآن';

  @override
  String get all_synced_up => 'كل شيء مزامن ومحدث!';

  @override
  String get waiting_to_upload => 'في انتظار الرفع للسيرفر';

  @override
  String get preparing_to_update => 'جاري التجهيز للتحديث';

  @override
  String get recipe_deleted_locally => 'الوصفة محذوفة محلياً ومؤقتاً';

  @override
  String get id_label => 'المعرف';
}
