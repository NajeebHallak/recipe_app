import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/errors/failure.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/features/sync/domain/repositories/sync_repo.dart';
import 'package:recipe/features/sync/presentation/cubits/sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final SyncRepo _repository;
  List<SyncRequestModel> _pendingOperations = [];

  List<SyncRequestModel> get pendingOperations => _pendingOperations;

  SyncCubit(this._repository) : super(SyncInitial()) {
    checkPendingOperations();
  }

  Future<void> checkPendingOperations() async {
    _pendingOperations = await _repository.getPendingSyncRequests();
    emit(SyncStatusUpdated(_pendingOperations));
  }

  Future<void> syncPendingOperations() async {
    if (_pendingOperations.isEmpty) return;

    emit(SyncInProgress());

    Either<Failure, Unit> result = await _repository.syncPendingRequests();

    result.fold(
      (failure) {
        emit(SyncError(failure.errorMassage));
        checkPendingOperations();
      },
      (_) {
        emit(SyncSuccess());
        checkPendingOperations();
      },
    );
  }
}
