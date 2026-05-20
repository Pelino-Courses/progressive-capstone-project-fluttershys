/// Simulates network latency for the local mock backend.
Future<void> mockNetworkDelay([
  Duration duration = const Duration(milliseconds: 280),
]) async {
  await Future<void>.delayed(duration);
}
