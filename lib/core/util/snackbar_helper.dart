import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';

class SnackBarHelper {
  // 🟢 تنبيه النجاح
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _showSnackBar(
      context,
      message: message,
      title: title ?? context.l10n.success,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  // 🔴 تنبيه الخطأ
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _showSnackBar(
      context,
      message: message,
      title: title ?? context.l10n.error_occurred,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_outline,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required String title,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.kRadiusMedium12),
        margin: EdgeInsets.all(20.rW),
        elevation: 4,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30.rSp),
            AppGap.w12,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.rSp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 14.rSp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
