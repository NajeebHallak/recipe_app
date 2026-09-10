import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  // 1️⃣ تهيئة المكتبة عند بداية تشغيل التطبيق (مرة واحدة فقط)
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // 2️⃣ دالة عامة لحفظ الأرقام، النصوص، أو البولين (Boolean)
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);
    return false;
  }

  // 3️⃣ دالة عامة لقراءة البيانات
  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  // 4️⃣ دالة حذف مفتاح معين (عند تسجيل الخروج مثلاً)
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }
}
