import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../widgets/adaptive_app_shell.dart';
import '../profile/profile_page.dart';
import 'admin_console_page.dart';
import 'cart_page.dart';
import 'marketplace_page.dart';
import 'my_products_page.dart';
import 'orders_page.dart';
import 'vendor_orders_page.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.shellTabRequest > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _currentIndex = appState.shellTabRequest);
        appState.clearShellTabRequest();
      });
    }

    final isAdmin = appState.isAdmin;
    final isVendor = appState.isVendor;

    final destinations = <ShellDestination>[
      const ShellDestination(
        icon: Icons.storefront_outlined,
        selectedIcon: Icons.storefront,
        label: 'Shop',
      ),
      ShellDestination(
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart,
        label: appState.cartItemCount > 0
            ? 'Cart (${appState.cartItemCount})'
            : 'Cart',
      ),
      if (isVendor && !isAdmin)
        const ShellDestination(
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
          label: 'Listings',
        ),
      if (isVendor && !isAdmin)
        const ShellDestination(
          icon: Icons.local_shipping_outlined,
          selectedIcon: Icons.local_shipping,
          label: 'Sales',
        ),
      if (!isVendor || isAdmin)
        const ShellDestination(
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
          label: 'Orders',
        ),
      if (isAdmin)
        const ShellDestination(
          icon: Icons.admin_panel_settings_outlined,
          selectedIcon: Icons.admin_panel_settings,
          label: 'Admin',
        ),
      const ShellDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    final pages = <Widget>[
      const MarketplacePage(),
      const CartPage(),
      if (isVendor && !isAdmin) const MyProductsPage(),
      if (isVendor && !isAdmin) const VendorOrdersPage(),
      if (!isVendor || isAdmin) const OrdersPage(),
      if (isAdmin) const AdminConsolePage(),
      const ProfilePage(),
    ];

    final titles = <String>[
      'Marketplace',
      'Cart',
      if (isVendor && !isAdmin) 'My Listings',
      if (isVendor && !isAdmin) 'Seller Orders',
      if (!isVendor || isAdmin) 'My Orders',
      if (isAdmin) 'Admin Console',
      'Profile',
    ];

    final safeIndex = _currentIndex.clamp(0, pages.length - 1);

    return AdaptiveAppShell(
      title: titles[safeIndex],
      selectedIndex: safeIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: destinations,
      actions: [
        IconButton(
          tooltip: 'Sign Out',
          onPressed: () async {
            await context.read<AppState>().signOut();
          },
          icon: const Icon(Icons.logout),
        ),
        if (isAdmin)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Chip(
              avatar: Icon(Icons.verified_user, size: 18),
              label: Text('Admin'),
            ),
          ),
        if (isVendor && !isAdmin)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Chip(
              avatar: Icon(Icons.store, size: 18),
              label: Text('Vendor'),
            ),
          ),
      ],
      body: pages[safeIndex],
    );
  }
}
