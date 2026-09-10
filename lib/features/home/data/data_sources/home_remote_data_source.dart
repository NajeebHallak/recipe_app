import 'package:recipe/core/services/api_service.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/data/models/recipe_request.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes();
  Future<void> addRecipe(RecipeRequest request);
  Future<void> updateRecipe(RecipeRequest request);
  Future<void> deleteRecipe(int id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<RecipeModel>> getRecipes() async {
    // استخدام ApiService كما طلبت
    dynamic data = await apiService.get(endpoint: '/recipes');

    List<RecipeModel> recipes = (data as List)
        .map((json) => RecipeModel.fromJson(json))
        .toList();

    return recipes;
  }

  @override
  Future<void> addRecipe(RecipeRequest request) async {
    FormData formData = FormData.fromMap({
      'title_ar': request.titleAr,
      'title_en': request.titleEn,
      if (request.detailsAr != null) 'details_ar': request.detailsAr,
      if (request.detailsEn != null) 'details_en': request.detailsEn,
      'category': request.category,
    });

    if (request.imagePath != null) {
      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(request.imagePath!)),
      );
    }

    await apiService.post(
      endpoint: '/recipes',
      data: formData,
      isFormData: true,
    );
  }

  @override
  Future<void> updateRecipe(RecipeRequest request) async {
    FormData formData = FormData.fromMap({
      'title_ar': request.titleAr,
      'title_en': request.titleEn,
      if (request.detailsAr != null) 'details_ar': request.detailsAr,
      if (request.detailsEn != null) 'details_en': request.detailsEn,
      'category': request.category,
    });

    if (request.imagePath != null) {
      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(request.imagePath!)),
      );
    }

    await apiService.put(
      endpoint: '/recipes/${request.id}',
      data: formData,
      isFormData: true,
    );
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await apiService.delete(endpoint: '/recipes/$id');
  }
}
