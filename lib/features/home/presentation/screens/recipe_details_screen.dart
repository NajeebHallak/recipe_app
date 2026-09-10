import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/widgets/recipe_image_widget.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeModel? recipe;

  const RecipeDetailsScreen({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe == null) {
      return Scaffold(body: Center(child: Text(context.l10n.error_occurred)));
    }

    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final title = isAr ? recipe!.titleAr : recipe!.titleEn;
    final details = isAr ? recipe!.detailsAr : recipe!.detailsEn;

    String? imagePath = recipe!.imageUrl.isNotEmpty
        ? recipe!.imageUrl.first
        : null;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // القسم العلوي: الصورة الكبيرة في AppBar
            SliverAppBar(
              expandedHeight: 300.rH,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: RecipeImageWidget(
                  imagePath: imagePath ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Share logic
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {
                    // TODO: Print logic
                  },
                ),
              ],
            ),

            // القسم السفلي: التفاصيل
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.rW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24.rSp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppGap.h16,
                    Row(
                      children: [
                        _buildInfoChip(
                          context,
                          Icons.people,
                          '${recipe!.servings} ${context.l10n.persons}',
                          Colors.green,
                        ),
                        AppGap.w16,
                        _buildInfoChip(
                          context,
                          Icons.timer,
                          '${recipe!.prepTime} ${context.l10n.mins}',
                          Colors.green,
                        ),
                      ],
                    ),
                    AppGap.h24,
                    Text(
                      context.l10n.instructions,
                      style: TextStyle(
                        fontSize: 18.rSp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppGap.h16,
                    Text(
                      details,
                      style: TextStyle(fontSize: 16.rSp, height: 1.8),
                    ),
                    // مساحة إضافية في الأسفل لضمان إمكانية التمرير لنهاية النص بارتياح
                    AppGap.h50,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.rW, vertical: 8.rH),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.rW),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.rSp),
          AppGap.w8,
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14.rSp,
            ),
          ),
        ],
      ),
    );
  }
}
