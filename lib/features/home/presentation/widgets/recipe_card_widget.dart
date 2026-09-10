import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/widgets/recipe_image_widget.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';

class RecipeCardWidget extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecipeCardWidget({
    super.key,
    required this.recipe,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد اللغة لكي نختار الحقل المناسب
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final title = isAr ? recipe.titleAr : recipe.titleEn;
    final details = isAr ? recipe.detailsAr : recipe.detailsEn;

    // تحديد مسار الصورة إذا كان موجوداً
    String? imagePath = recipe.imageUrl.isNotEmpty
        ? recipe.imageUrl.first
        : null;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.kRadiusMedium12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // القسم العلوي: الصورة مع الأزرار العائمة
          SizedBox(
            height: 200.rH, // ارتفاع ثابت وجميل للصورة
            child: Stack(
              fit: StackFit.expand,
              children: [
                // الصورة
                RecipeImageWidget(
                  imagePath: imagePath ?? '',
                  fit: BoxFit.cover,
                ),

                // زر المفضلة في أعلى اليمين (أو اليسار حسب اللغة)
                Positioned(
                  top: 8.rH,
                  right:
                      8.rW, // Assuming Arabic UI (RTL), right is logical left
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // TODO: Toggle favorite
                      },
                    ),
                  ),
                ),

                // أزرار التعديل والحذف
                Positioned(
                  top: 8.rH,
                  left: 8.rW,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: onEdit,
                        ),
                      ),
                      AppGap.w8,
                      CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: onDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // القسم السفلي: التفاصيل
          Padding(
            padding: EdgeInsets.all(16.rW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize:
                        18.rSp, // تكبير العنوان قليلاً لأنه عنصر واحد بالصف
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppGap.h8,
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 14.rSp,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppGap.h16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people, size: 14.rSp, color: Colors.green),
                        AppGap.w4,
                        Text(
                          '${recipe.servings} ${context.l10n.persons}',
                          style: TextStyle(fontSize: 12.rSp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14.rSp, color: Colors.green),
                        AppGap.w4,
                        Text(
                          '${recipe.prepTime} ${context.l10n.mins}',
                          style: TextStyle(fontSize: 12.rSp),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
