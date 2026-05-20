import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../widgets/adaptive_app_shell.dart';
import '../profile/profile_page.dart';
import 'cart_page.dart';
import 'feedback_page.dart';
import 'marketplace_page.dart';
import 'orders_page.dart';

/// Buyer / client: browse, cart, own orders, feedback.
class ClientDashboardShell extends StatefulWidget {
  const ClientDashboardShell({super.key});

  static const int cartTabIndex = 1;

  @override
  State<ClientDashboardShell> createState() => _ClientDashboardShellState();
}

class _ClientDashboardShellState extends State<ClientDashboardShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.hasPendingOpenCart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (appState.takePendingOpenCart()) {
          setState(() => _currentIndex = ClientDashboardShell.cartTabIndex);
        }
      });
    }

    const tabDefs = <ShellDestination>[
      ShellDestination(
        icon: Icons.storefront_outlined,
        selectedIcon: Icons.storefront,
        label: 'Shop',
      ),
      ShellDestination(
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart,
        label: 'Cart',
      ),
      ShellDestination(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'My orders',
      ),
      ShellDestination(
        icon: Icons.rate_review_outlined,
        selectedIcon: Icons.rate_review,
        label: 'Feedback',
      ),
      ShellDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    const pages = <Widget>[
      MarketplacePage(),
      CartPage(),
      OrdersPage(),
      FeedbackPage(),
      ProfilePage(),
    ];

    const titles = <String>[
      'Shop',
      'Cart',
      'My orders',
      'Feedback',
      'Profile',
    ];

    final safeIndex = _currentIndex.clamp(0, pages.length - 1);

    return AdaptiveAppShell(
      title: titles[safeIndex],
      selectedIndex: safeIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: [
        for (var i = 0; i < tabDefs.length; i++)
          i == 1
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
      ],
      body: pages[safeIndex],
    );
  }
}
