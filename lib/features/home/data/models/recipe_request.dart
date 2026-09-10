import 'dart:convert';

class RecipeRequest {
  final int? id; // يستخدم فقط في التعديل
  final String titleAr;
  final String titleEn;
  final String? detailsAr;
  final String? detailsEn;
  final String category;
  final String? imagePath; // مسار الصورة في الجهاز (Local File Path)

  RecipeRequest({
    this.id,
    required this.titleAr,
    required this.titleEn,
    this.detailsAr,
    this.detailsEn,
    required this.category,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'title_ar': titleAr,
      'title_en': titleEn,
      if (detailsAr != null) 'details_ar': detailsAr,
      if (detailsEn != null) 'details_en': detailsEn,
      'category': category,
    };
  }

  String toJson() => json.encode(toMap());

  factory RecipeRequest.fromJson(String source) {
    final map = json.decode(source);
    return RecipeRequest(
      titleAr: map['title_ar'] ?? '',
      titleEn: map['title_en'] ?? '',
      detailsAr: map['details_ar'],
      detailsEn: map['details_en'],
      category: map['category'] ?? '',
      // imagePath & id are usually not needed when decoding for UI, but useful for SyncRequest
    );
  }
}
