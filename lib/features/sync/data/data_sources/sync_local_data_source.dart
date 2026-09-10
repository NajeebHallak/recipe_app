import 'package:recipe/features/sync/data/models/sync_request_model.dart';
import 'package:recipe/main.dart';
import 'package:objectbox/objectbox.dart';

abstract class SyncLocalDataSource {
  Future<void> cacheSyncRequest(SyncRequestModel request);
  Future<List<SyncRequestModel>> getPendingSyncRequests();
  Future<void> removeSyncRequest(int id);
}

class SyncLocalDataSourceImpl implements SyncLocalDataSource {
  final Box<SyncRequestModel> _syncBox = objectBox.store
      .box<SyncRequestModel>();

  @override
  Future<void> cacheSyncRequest(SyncRequestModel request) async {
    _syncBox.put(request);
  }

  @override
  Future<List<SyncRequestModel>> getPendingSyncRequests() async {
    return _syncBox.getAll();
  }

  @override
  Future<void> removeSyncRequest(int id) async {
    _syncBox.remove(id);
  }
}
