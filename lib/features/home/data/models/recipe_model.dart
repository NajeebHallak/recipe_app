import 'package:objectbox/objectbox.dart';

@Entity()
class RecipeModel {
  @Id(assignable: true)
  int id;

  String titleAr;
  String titleEn;
  String detailsAr;
  String detailsEn;
  List<String> imageUrl;
  String createdAt;
  int prepTime;
  int servings;
  String category;

  RecipeModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.detailsAr,
    required this.detailsEn,
    required this.imageUrl,
    required this.createdAt,
    required this.prepTime,
    required this.servings,
    required this.category,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = [];
    if (json['image_url'] != null) {
      if (json['image_url'] is String) {
        if (json['image_url'].toString().isNotEmpty) {
          parsedImages = [json['image_url']];
        }
      } else if (json['image_url'] is Iterable) {
        parsedImages = List<String>.from(json['image_url']);
      }
    }

    return RecipeModel(
      id: json['id'],
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      detailsAr: json['details_ar'] ?? '',
      detailsEn: json['details_en'] ?? '',
      imageUrl: parsedImages,
      createdAt: json['created_at'] ?? '',
      prepTime: json['prep_time'] ?? 0,
      servings: json['servings'] ?? 0,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'details_ar': detailsAr,
      'details_en': detailsEn,
      'image_url': imageUrl,
      'created_at': createdAt,
      'prep_time': prepTime,
      'servings': servings,
      'category': category,
    };
  }
}
