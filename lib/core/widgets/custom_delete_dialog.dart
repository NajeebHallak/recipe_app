import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.kRadiusMedium12),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.rSp,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: Text(content, style: TextStyle(fontSize: 16.rSp)),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(); // إلغاء
          },
          child: Text(
            'إلغاء', // TODO: Use context.l10n for translations
            style: TextStyle(color: Colors.grey, fontSize: 14.rSp),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.kRadiusSmall8,
            ),
          ),
          onPressed: () {
            context.pop(); // أغلق النافذة أولاً
            onConfirm(); // نفذ عملية الحذف
          },
          child: Text(
            'حذف', // TODO: Use context.l10n
            style: TextStyle(color: Colors.white, fontSize: 14.rSp),
          ),
        ),
      ],
    );
  }
}
