import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_cubit.dart';
import 'package:recipe/features/sync/presentation/widgets/sync_request_item_widget.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';

class SyncBottomSheetContent extends StatelessWidget {
  final List<SyncRequestModel> pendingOps;
  final bool isSyncing;

  const SyncBottomSheetContent({
    super.key,
    required this.pendingOps,
    required this.isSyncing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      // تحديد أقصى ارتفاع للـ BottomSheet بنسبة 80% من الشاشة للحصول على ميزة التمرير
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: EdgeInsets.only(
        top: 12.rH,
        left: 24.rW,
        right: 24.rW,
        bottom:
            MediaQuery.of(context).padding.bottom +
            20.rH, // تجنب زر العودة في الايفون
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.rW)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب العلوي (Drag Handle)
          Container(
            width: 50.rW,
            height: 5.rH,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: AppRadius.kRadiusSmall8,
            ),
          ),
          AppGap.h24,

          // العنوان
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.rW),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_sync_rounded,
                  color: colorScheme.primary,
                  size: 28.rSp,
                ),
              ),
              AppGap.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.smart_sync_center,
                      style: TextStyle(
                        fontSize: 20.rSp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    AppGap.h4,
                    Text(
                      context.l10n.pending_sync_operations(pendingOps.length),
                      style: TextStyle(
                        fontSize: 14.rSp,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppGap.h24,

          // قائمة العمليات (مع ميزة الـ Scroll)
          Flexible(
            child: pendingOps.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: pendingOps.length,
                    itemBuilder: (context, index) {
                      return SyncRequestItemWidget(
                        operation: pendingOps[index],
                      );
                    },
                  ),
          ),

          AppGap.h24,

          // زر المزامنة
          if (pendingOps.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 56.rH,
              child: ElevatedButton(
                onPressed: isSyncing
                    ? null
                    : () {
                        context.read<SyncCubit>().syncPendingOperations();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 5,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.kRadiusLarge16,
                  ),
                ),
                child: isSyncing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24.rW,
                            height: 24.rW,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                          AppGap.w12,
                          Text(
                            context.l10n.uploading_data,
                            style: TextStyle(
                              fontSize: 16.rSp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rocket_launch_rounded, size: 22.rSp),
                          AppGap.w12,
                          Text(
                            context.l10n.start_sync_now,
                            style: TextStyle(
                              fontSize: 16.rSp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppGap.h24,
        Icon(
          Icons.cloud_done_rounded,
          size: 80.rSp,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        ),
        AppGap.h16,
        Text(
          context.l10n.all_synced_up,
          style: TextStyle(
            fontSize: 18.rSp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        AppGap.h32,
      ],
    );
  }
}
