import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../widgets/adaptive_app_shell.dart';
import '../profile/profile_page.dart';
import 'admin_orders_page.dart';
import 'admin_overview_page.dart';
import 'cart_page.dart';
import 'marketplace_page.dart';

/// Platform admin: overview, browse, global orders, optional personal cart for testing.
class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  static const int cartTabIndex = 3;

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.hasPendingOpenCart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (appState.takePendingOpenCart()) {
          setState(() => _currentIndex = AdminDashboardShell.cartTabIndex);
        }
      });
    }

    const tabDefs = <ShellDestination>[
      ShellDestination(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Dashboard',
      ),
      ShellDestination(
        icon: Icons.storefront_outlined,
        selectedIcon: Icons.storefront,
        label: 'Shop',
      ),
      ShellDestination(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'All orders',
      ),
      ShellDestination(
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart,
        label: 'Cart',
      ),
      ShellDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    const pages = <Widget>[
      AdminOverviewPage(),
      MarketplacePage(),
      AdminOrdersPage(),
      CartPage(),
      ProfilePage(),
    ];

    const titles = <String>[
      'Admin dashboard',
      'Shop',
      'All orders',
      'Cart',
      'Profile',
    ];

    final safeIndex = _currentIndex.clamp(0, pages.length - 1);

    return AdaptiveAppShell(
      title: titles[safeIndex],
      selectedIndex: safeIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: [
        for (var i = 0; i < tabDefs.length; i++)
          i == 3
              ? ShellDestination(
                  icon: tabDefs[i].icon,
                  selectedIcon: tabDefs[i].selectedIcon,
                  label:
                      '${tabDefs[i].label}${appState.cartItemCount > 0 ? ' (${appState.cartItemCount})' : ''}',
                )
              : tabDefs[i],
      ],
      actions: [
        IconButton(
          tooltip: 'Sign out',
          onPressed: () => context.read<AppState>().signOut(),
          icon: const Icon(Icons.logout),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Chip(
            avatar: Icon(Icons.verified_user, size: 18),
            label: Text('Admin'),
          ),
        ),
      ],
      body: pages[safeIndex],
    );
  }
}
