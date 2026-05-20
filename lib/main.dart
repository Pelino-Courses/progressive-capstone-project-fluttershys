import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/auth/auth_gate.dart';
import 'services/app_services.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('FlutterError: ${details.exceptionAsString()}');
    }
  };

  ErrorWidget.builder = (details) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Something went wrong while building the UI.\n${details.exceptionAsString()}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  final services = await AppServices.create();
  runApp(FrutellaApp(services: services));
}

class FrutellaApp extends StatelessWidget {
  const FrutellaApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(services: services),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Frutella',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const AuthGate(),
      ),
    );
  }
}
