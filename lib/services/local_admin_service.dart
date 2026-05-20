import '../data/local_data_store.dart';

class LocalAdminService {
  LocalAdminService(this._store);

  final LocalDataStore _store;

  Future<void> setUserRole({
    required String targetUid,
    required String role,
  }) async {
    await _store.updateUserRole(targetUid, role);
  }

  Future<void> setUserSuspended({
    required String targetUid,
    required bool suspended,
  }) async {
    await _store.setUserSuspended(targetUid, suspended);
  }

  Future<void> sendCampaign({
    required String title,
    required String body,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
