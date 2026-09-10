import 'package:recipe/features/sync/data/models/sync_request_model.dart';

abstract class SyncState {}

class SyncInitial extends SyncState {}

class SyncStatusUpdated extends SyncState {
  final List<SyncRequestModel> pendingOperations;
  SyncStatusUpdated(this.pendingOperations);
}

class SyncInProgress extends SyncState {}

class SyncSuccess extends SyncState {}

class SyncError extends SyncState {
  final String message;
  SyncError(this.message);
}
