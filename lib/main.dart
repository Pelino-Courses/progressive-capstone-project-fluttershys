import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/auth/auth_gate.dart';
import 'services/mock_services.dart';
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

  final mockServices = await MockServicesFactory.create();
  runApp(FrutellaApp(mockServices: mockServices));
}

class FrutellaApp extends StatelessWidget {
  const FrutellaApp({super.key, required this.mockServices});

  final MockServices mockServices;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(
        authService: mockServices.authService,
        productService: mockServices.productService,
        feedbackService: mockServices.feedbackService,
        orderService: mockServices.orderService,
        adminService: mockServices.adminService,
        firestore: mockServices.firestore,
      ),
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
