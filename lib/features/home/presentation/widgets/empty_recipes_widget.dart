import 'package:flutter/material.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';

class EmptyRecipesWidget extends StatelessWidget {
  const EmptyRecipesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.rW),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.rW),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 80.rSp,
                color: Colors.red.shade400,
              ),
            ),
            AppGap.h24,
            Text(
              context.l10n.empty_recipes_title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.rSp,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppGap.h12,
            Text(
              context.l10n.empty_recipes_subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.rSp,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
