import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/app_state.dart';
import '../../widgets/product_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Product> _recent = const [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final recent = await context.read<AppState>().loadRecentlyViewedProducts();
    if (mounted) setState(() => _recent = recent);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profile = appState.profile;
    final favorites = appState.favoriteProducts;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Text(
                    (profile?.displayName ?? 'U').characters.first.toUpperCase(),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.displayName ?? 'Guest',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(profile?.email ?? ''),
                      Text('Role: ${_roleLabel(appState)}'),
                      Text('Cart items: ${appState.cartItemCount}'),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit name',
                  onPressed: () => _editName(context, appState),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (favorites.isNotEmpty) ...[
          Text('Favorites', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => SizedBox(
                width: 180,
                child: ProductCard(product: favorites[i], compact: true),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (_recent.isNotEmpty) ...[
          Text('Recently viewed', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recent.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => SizedBox(
                width: 180,
                child: ProductCard(product: _recent[i], compact: true),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        FilledButton.icon(
          onPressed: () async {
            await appState.signOut();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully.')),
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }

  String _roleLabel(AppState appState) {
    if (appState.isAdmin) return 'Admin';
    if (appState.isVendor) return 'Vendor';
    return 'Customer';
  }

  Future<void> _editName(BuildContext context, AppState appState) async {
    final ctrl = TextEditingController(text: appState.profile?.displayName);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit profile'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok == true) {
      await appState.updateProfile(displayName: ctrl.text.trim());
    }
    ctrl.dispose();
  }
}
