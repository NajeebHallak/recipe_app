import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/data/models/recipe_request.dart';
import 'package:recipe/features/home/domain/repositories/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  // القائمة الكاملة للوصفات (مصدر الحقيقة)
  List<RecipeModel> allRecipes = [];

  // القائمة المعروضة بعد الفلترة
  List<RecipeModel> displayedRecipes = [];

  // حالة الفلاتر
  String? currentCategory; // null means 'All'
  String searchQuery = '';
  bool showOnlyFavorites = false;

  // تطبيق كل الفلاتر وعرض النتيجة
  void _applyFilters() {
    displayedRecipes = allRecipes.where((recipe) {
      // 1. فلترة القسم
      bool categoryMatch = true;
      if (currentCategory != null && currentCategory!.isNotEmpty) {
        categoryMatch = recipe.category == currentCategory;
      }

      // 2. فلترة البحث
      bool searchMatch = true;
      if (searchQuery.isNotEmpty) {
        String query = searchQuery.toLowerCase();
        searchMatch =
            recipe.titleAr.toLowerCase().contains(query) ||
            recipe.titleEn.toLowerCase().contains(query);
      }

      // 3. فلترة المفضلة
      bool favoriteMatch = true;
      if (showOnlyFavorites) {
        favoriteMatch = recipe.isFavorite;
      }

      return categoryMatch && searchMatch && favoriteMatch;
    }).toList();

    if (!isClosed) emit(HomeGetRecipesSuccess(displayedRecipes));
  }

  // تغيير القسم
  void changeCategory(String? category) {
    currentCategory = category;
    _applyFilters();
  }

  // البحث
  void search(String query) {
    searchQuery = query;
    _applyFilters();
  }

  // تبديل عرض المفضلة
  void toggleFavoritesView() {
    showOnlyFavorites = !showOnlyFavorites;
    _applyFilters();
  }

  // تبديل حالة الوصفة (مفضلة / غير مفضلة)
  Future<void> toggleFavorite(RecipeModel recipe) async {
    recipe.isFavorite = !recipe.isFavorite;

    // تحديث الواجهة فوراً
    _applyFilters();

    // حفظ التغيير محلياً
    await homeRepo.toggleFavoriteLocal(recipe);
  }

  // إعادة جلب البيانات المحلية بعد تحديث صامت
  Future<void> _fetchLocalAndFilter() async {
    final localResult = await homeRepo.getRecipes();
    localResult.fold((_) {}, (recipes) {
      allRecipes = recipes;
      _applyFilters();
    });
  }

  Future<void> getRecipes() async {
    if (!isClosed) emit(HomeGetRecipesLoading());

    // 1. عرض البيانات المحلية فوراً
    final localResult = await homeRepo.getRecipes();
    localResult.fold(
      (failure) {
        if (!isClosed) emit(HomeGetRecipesError(failure.errorMassage));
      },
      (recipes) {
        allRecipes = recipes;
        _applyFilters();
      },
    );

    // 2. تحديث البيانات في الخلفية بصمت
    final remoteResult = await homeRepo.refreshRecipes();
    remoteResult.fold((failure) {}, (_) {
      // نجلب من اللوكال مرة أخرى لأن اللوكال داتا سورس قام بدمج الوصفات
      // الجديدة مع الحفاظ على قيم الـ isFavorite القديمة
      _fetchLocalAndFilter();
    });
  }

  // السحب للتحديث
  Future<void> refreshRecipes() async {
    final result = await homeRepo.refreshRecipes();
    result.fold(
      (failure) {
        if (!isClosed) emit(HomeGetRecipesError(failure.errorMassage));
      },
      (_) {
        _fetchLocalAndFilter();
      },
    );
  }

  // إضافة وصفة
  Future<void> addRecipe(RecipeRequest request) async {
    if (!isClosed) emit(HomeAddRecipeLoading());

    final result = await homeRepo.addRecipe(request);

    result.fold(
      (failure) {
        if (!isClosed) emit(HomeAddRecipeError(failure.errorMassage));
      },
      (_) {
        if (!isClosed) emit(HomeAddRecipeSuccess());
        _fetchLocalAndFilter();
      },
    );
  }

  // تعديل وصفة
  Future<void> updateRecipe(RecipeRequest request) async {
    if (!isClosed) emit(HomeUpdateRecipeLoading());

    final result = await homeRepo.updateRecipe(request);

    result.fold(
      (failure) {
        if (!isClosed) emit(HomeUpdateRecipeError(failure.errorMassage));
      },
      (_) {
        if (!isClosed) emit(HomeUpdateRecipeSuccess());
        _fetchLocalAndFilter();
      },
    );
  }

  // حذف وصفة
  Future<void> deleteRecipe(int id) async {
    if (!isClosed) emit(HomeDeleteRecipeLoading());

    final result = await homeRepo.deleteRecipe(id);

    result.fold(
      (failure) {
        if (!isClosed) emit(HomeDeleteRecipeError(failure.errorMassage));
      },
      (_) {
        if (!isClosed) emit(HomeDeleteRecipeSuccess());
        _fetchLocalAndFilter();
      },
    );
  }
}
