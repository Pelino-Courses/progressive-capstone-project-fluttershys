import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../widgets/adaptive_app_shell.dart';
import '../profile/profile_page.dart';
import 'cart_page.dart';
import 'marketplace_page.dart';
import 'my_products_page.dart';
import 'vendor_orders_page.dart';

/// Vendor: manage listings and view sales; can still shop as a customer.
class VendorDashboardShell extends StatefulWidget {
  const VendorDashboardShell({super.key});

  static const int cartTabIndex = 3;

  @override
  State<VendorDashboardShell> createState() => _VendorDashboardShellState();
}

class _VendorDashboardShellState extends State<VendorDashboardShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.hasPendingOpenCart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (appState.takePendingOpenCart()) {
          setState(() => _currentIndex = VendorDashboardShell.cartTabIndex);
        }
      });
    }

    const tabDefs = <ShellDestination>[
      ShellDestination(
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Listings',
      ),
      ShellDestination(
        icon: Icons.point_of_sale_outlined,
        selectedIcon: Icons.point_of_sale,
        label: 'Sales',
      ),
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
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    const pages = <Widget>[
      MyProductsPage(),
      VendorOrdersPage(),
      MarketplacePage(),
      CartPage(),
      ProfilePage(),
    ];

    const titles = <String>[
      'My listings',
      'Sales',
      'Shop',
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
            avatar: Icon(Icons.storefront, size: 18),
            label: Text('Vendor'),
          ),
        ),
      ],
      body: pages[safeIndex],
    );
  }
}
