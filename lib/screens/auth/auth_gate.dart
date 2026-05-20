import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../dashboard/admin_dashboard_shell.dart';
import '../dashboard/client_dashboard_shell.dart';
import '../dashboard/public_shell.dart';
import '../dashboard/vendor_dashboard_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!appState.isAuthenticated) {
          return const PublicShell();
        }

        if (appState.isAdmin) {
          return const AdminDashboardShell();
        }
        if (appState.isVendor) {
          return const VendorDashboardShell();
        }
        return const ClientDashboardShell();
      },
    );
  }
}
