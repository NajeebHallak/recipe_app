import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_cubit.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_state.dart';
import 'package:recipe/features/sync/presentation/widgets/sync_bottom_sheet.dart';

class HomeSyncCloudButton extends StatelessWidget {
  const HomeSyncCloudButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.rH),
        child: BlocBuilder<SyncCubit, SyncState>(
          builder: (context, state) {
            final pendingCount = context
                .read<SyncCubit>()
                .pendingOperations
                .length;
            if (pendingCount == 0) return const SizedBox.shrink();

            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<SyncCubit>(),
                    child: const SyncBottomSheet(),
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(14.rW),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.cloud_sync_rounded,
                      color: colorScheme.primary,
                      size: 28.rSp,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: EdgeInsets.all(6.rW),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.error.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        pendingCount.toString(),
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontSize: 12.rSp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
