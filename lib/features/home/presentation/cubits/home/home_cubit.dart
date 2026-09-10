import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/data/models/recipe_request.dart';
import 'package:recipe/features/home/domain/repositories/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  // الاحتفاظ بالقائمة محلياً داخل الكيوبت
  List<RecipeModel> recipesList = [];

  // جلب البيانات (عرض من اللوكال ثم التحديث بالخلفية)
  Future<void> getRecipes() async {
    if (!isClosed) emit(HomeGetRecipesLoading());

    // 1. عرض البيانات المحلية فوراً
    final localResult = await homeRepo.getRecipes();
    localResult.fold(
      (failure) {
        if (!isClosed) emit(HomeGetRecipesError(failure.errorMassage));
      },
      (recipes) {
        recipesList = recipes;
        if (!isClosed) emit(HomeGetRecipesSuccess(recipesList));
      },
    );

    // 2. تحديث البيانات في الخلفية بصمت
    final remoteResult = await homeRepo.refreshRecipes();
    remoteResult.fold(
      (failure) {
        // يمكننا تجاهل الخطأ في الخلفية لكي لا نزعج المستخدم إذا كان أوفلاين
        // أو إظهاره إذا أردنا
      },
      (recipes) {
        // تحديث القائمة الصامت
        recipesList = recipes;
        if (!isClosed) emit(HomeGetRecipesSuccess(recipesList));
      },
    );
  }

  // تحديث صريح للسحب للتحديث (Pull to Refresh)
  Future<void> refreshRecipes() async {
    final result = await homeRepo.refreshRecipes();
    result.fold(
      (failure) {
        if (!isClosed) emit(HomeGetRecipesError(failure.errorMassage));
      },
      (recipes) {
        recipesList = recipes;
        if (!isClosed) emit(HomeGetRecipesSuccess(recipesList));
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
        // إعادة جلب البيانات فوراً لكي تظهر الوصفة الجديدة على الشاشة
        // بسبب الـ Optimistic Update ستظهر فوراً من الـ Local
        getRecipes();
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
        getRecipes();
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
        getRecipes();
      },
    );
  }
}
