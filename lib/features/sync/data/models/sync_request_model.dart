import 'package:objectbox/objectbox.dart';

@Entity()
class SyncRequestModel {
  @Id()
  int id = 0; // ID داخلي للـ ObjectBox

  final String method; // POST, PUT, DELETE
  final String endpoint; // رابط الـ API، مثلا: /recipes أو /recipes/15
  final String? payloadJson; // الـ Body كـ String
  final String? imagePath; // مسار الصورة المحلي (لو وجدت) لرفعها Multipart
  final int?
  recipeId; // نحتفظ بالـ ID الخاص بالوصفة حتى لو كان وهمياً لربطه لاحقاً

  SyncRequestModel({
    this.id = 0,
    required this.method,
    required this.endpoint,
    this.payloadJson,
    this.imagePath,
    this.recipeId,
  });
}
