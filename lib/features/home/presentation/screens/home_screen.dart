import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_state.dart';
import 'package:recipe/features/home/presentation/widgets/home_app_bar.dart';
import 'package:recipe/features/home/presentation/widgets/home_body.dart';
import 'package:recipe/features/home/presentation/widgets/home_floating_action_button.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_cubit.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_state.dart';
import 'package:recipe/features/home/presentation/widgets/home_sync_cloud_button.dart';

class HomeScrean extends StatelessWidget {
  const HomeScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              current is HomeAddRecipeSuccess ||
              current is HomeUpdateRecipeSuccess ||
              current is HomeDeleteRecipeSuccess,
          listener: (context, state) {
            context.read<SyncCubit>().checkPendingOperations();
          },
          child: BlocListener<SyncCubit, SyncState>(
            listener: (context, state) {
              if (state is SyncSuccess) {
                // تحديث واجهة المستخدم بالوصفات الحقيقية بمجرد انتهاء المزامنة
                context.read<HomeCubit>().refreshRecipes();
              }
            },
            child: SizedBox.expand(
              child: Stack(
                children: [const HomeBody(), const HomeSyncCloudButton()],
              ),
            ),
          ),
        ),
        floatingActionButton: const HomeFloatingActionButton(),
      ),
    );
  }
}
