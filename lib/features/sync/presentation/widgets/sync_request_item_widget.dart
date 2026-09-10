import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';

class SyncRequestItemWidget extends StatelessWidget {
  final SyncRequestModel operation;

  const SyncRequestItemWidget({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;
    Color iconColor;
    Color bgColor;
    String title;
    String subtitleText;

    if (operation.method == 'POST') {
      icon = Icons.add_circle_rounded;
      iconColor = Colors.green;
      bgColor = Colors.green.withValues(alpha: 0.1);
      title = context.l10n.add_recipe;
      subtitleText = context.l10n.waiting_to_upload;
    } else if (operation.method == 'PUT') {
      icon = Icons.edit_rounded;
      iconColor = Colors.orange;
      bgColor = Colors.orange.withValues(alpha: 0.1);
      title = context.l10n.edit_recipe;
      subtitleText = context.l10n.preparing_to_update;
    } else {
      icon = Icons.delete_rounded;
      iconColor = colorScheme.error;
      bgColor = colorScheme.error.withValues(alpha: 0.1);
      title = context.l10n.delete_recipe;
      subtitleText = context.l10n.recipe_deleted_locally;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.rH),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.kRadiusMedium12,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.kRadiusMedium12,
          onTap: () {
            // يمكن مستقبلاً إضافة تفاصيل عند الضغط
          },
          child: Padding(
            padding: EdgeInsets.all(16.rW),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.rW),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24.rSp),
                ),
                AppGap.w16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.rSp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      AppGap.h4,
                      Text(
                        '$subtitleText • ${context.l10n.id_label}: ${operation.id}',
                        style: TextStyle(
                          fontSize: 12.rSp,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.cloud_upload_outlined,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  size: 20.rSp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
