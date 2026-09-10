import 'package:dartz/dartz.dart';
import 'package:recipe/core/errors/failure.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';

abstract class SyncRepo {
  Future<void> queueRequest(SyncRequestModel request);
  Future<List<SyncRequestModel>> getPendingSyncRequests();
  Future<Either<Failure, Unit>> syncPendingRequests();
}
