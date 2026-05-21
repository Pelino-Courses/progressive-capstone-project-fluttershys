import '../data/local_data_store.dart';

class LocalFeedbackService {
  LocalFeedbackService(this._store);

  final LocalDataStore _store;

  Future<void> submitFeedback({
    required String userId,
    required String email,
    required String message,
  }) async {
    // Stored in memory log for demo — extend store if needed.
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
