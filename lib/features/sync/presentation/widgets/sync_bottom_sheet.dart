import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/util/snackbar_helper.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_state.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_cubit.dart';
import 'package:recipe/features/sync/presentation/widgets/sync_bottom_sheet_content.dart';

class SyncBottomSheet extends StatelessWidget {
  const SyncBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncCubit, SyncState>(
      listener: (context, state) {
        if (state is SyncSuccess) {
          SnackBarHelper.showSuccess(
            context,
            message: 'تمت مزامنة العمليات بنجاح! السحابة الآن نظيفة ☁️✨',
          );
          Navigator.pop(context);
        } else if (state is SyncError) {
          SnackBarHelper.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        List<SyncRequestModel> pendingOps = context
            .read<SyncCubit>()
            .pendingOperations;
        final bool isSyncing = state is SyncInProgress;

        return SyncBottomSheetContent(
          pendingOps: pendingOps,
          isSyncing: isSyncing,
        );
      },
    );
  }
}
