import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';

class HomeCategoriesWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const HomeCategoriesWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.rH,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 16.rW),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final isFavorite = category == context.l10n.favorites;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(
                left: 8.rW,
                bottom: 4.rH,
              ), // bottom margin for shadow
              padding: EdgeInsets.symmetric(horizontal: 20.rW),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isFavorite ? Colors.red : Colors.green)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20.rW),
                border: Border.all(
                  color: isSelected
                      ? (isFavorite ? Colors.red : Colors.green)
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isFavorite ? Colors.red : Colors.green)
                              .withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFavorite) ...[
                      Icon(
                        isSelected ? Icons.favorite : Icons.favorite_border,
                        color: isSelected ? Colors.white : Colors.red,
                        size: 16.rSp,
                      ),
                      AppGap.w4,
                    ],
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isFavorite
                                ? Colors.red
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 15.rSp : 13.rSp, // تكبير خفيف
                        fontFamily: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.fontFamily,
                      ),
                      child: Text(category),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
