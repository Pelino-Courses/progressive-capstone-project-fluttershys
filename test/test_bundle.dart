import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sukaapp/data/local_data_store.dart';
import 'package:sukaapp/providers/app_state.dart';
import 'package:sukaapp/services/app_services.dart';

class TestBundle {
  TestBundle({required this.appState, required this.services});

  final AppState appState;
  final AppServices services;
}

Future<TestBundle> createTestBundle({
  bool signedIn = true,
  bool isAdmin = false,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await LocalDataStore.instance.resetForTests();

  if (isAdmin) {
    await LocalDataStore.instance.signIn(
      email: 'admin@frutella.test',
      password: 'Admin123!',
    );
  } else if (signedIn) {
    await LocalDataStore.instance.signIn(
      email: 'demo@frutella.test',
      password: 'Demo123!',
    );
  }

  final services = AppServices.fromStore(LocalDataStore.instance);
  final appState = AppState(services: services);
  await appState.ready;

  return TestBundle(appState: appState, services: services);
}
