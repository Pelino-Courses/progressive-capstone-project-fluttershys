import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../providers/app_state.dart';
import '../../widgets/product_image.dart';

class AdminConsolePage extends StatelessWidget {
  const AdminConsolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (!appState.isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Access denied. Admin only.')),
      );
    }

    final products = appState.store.products;
    final orders = appState.store.orders;
    final users = appState.store.users;
    final vendors = users.where((u) => u.isVendor).length;
    final buyers = users.where((u) => u.isBuyer).length;
    final lowStock = products.where((p) => p.stockQuantity < 10).length;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Platform control',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatCard(
                      icon: Icons.people_outline,
                      label: 'Sellers',
                      value: '$vendors',
                    ),
                    _StatCard(
                      icon: Icons.person_outline,
                      label: 'Customers',
                      value: '$buyers',
                    ),
                    _StatCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Products',
                      value: '${products.length}',
                    ),
                    _StatCard(
                      icon: Icons.receipt_long_outlined,
                      label: 'Orders',
                      value: '${orders.length}',
                    ),
                    _StatCard(
                      icon: Icons.warning_amber_outlined,
                      label: 'Low stock',
                      value: '$lowStock',
                      highlight: lowStock > 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Products'),
              Tab(text: 'Orders'),
              Tab(text: 'Broadcast'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                _UsersTab(),
                _ProductsTab(),
                _OrdersTab(),
                _CampaignTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: highlight ? scheme.errorContainer : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppUser>>(
      stream: context.read<AppState>().store.usersStream,
      initialData: context.read<AppState>().store.users,
      builder: (context, snapshot) {
        final users = snapshot.data ?? const <AppUser>[];
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              child: ListTile(
                title: Text(user.displayName),
                subtitle: Text(
                  '${user.email}\nRole: ${user.role.label}${user.isSuspended ? ' • SUSPENDED' : ''}',
                ),
                isThreeLine: true,
                trailing: SizedBox(
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        isExpanded: true,
                        value: user.role.label,
                        items: const [
                          DropdownMenuItem(value: 'buyer', child: Text('buyer')),
                          DropdownMenuItem(value: 'vendor', child: Text('vendor')),
                          DropdownMenuItem(value: 'admin', child: Text('admin')),
                        ],
                        onChanged: (value) async {
                          if (value == null) return;
                          await context.read<AppState>().setUserRole(
                            targetUid: user.uid,
                            role: value,
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          await context.read<AppState>().setUserSuspended(
                            targetUid: user.uid,
                            suspended: !user.isSuspended,
                          );
                        },
                        child: Text(user.isSuspended ? 'Unsuspend' : 'Suspend'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return StreamBuilder<List<Product>>(
      stream: appState.productService.streamAllProductsAdmin(),
      initialData: appState.store.products,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <Product>[];
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            return Card(
              child: ListTile(
                leading: SizedBox(
                  width: 48,
                  height: 48,
                  child: ProductImage(
                    imageUrl: product.imageUrl,
                    aspectRatio: 1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: Text(product.name),
                subtitle: Text(
                  '${product.ownerName} • ${product.price.toStringAsFixed(0)} RWF\n'
                  'Stock: ${product.stockQuantity} • ${product.isApproved ? 'Approved' : 'Pending'}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: product.isApproved ? 'Reject' : 'Approve',
                      onPressed: () => appState.setProductApproval(
                        product.id,
                        !product.isApproved,
                      ),
                      icon: Icon(
                        product.isApproved ? Icons.block : Icons.check_circle,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () => appState.productService.deleteProduct(
                        productId: product.id,
                        productOwnerId: product.ownerId,
                        isAdmin: true,
                        currentUserId: appState.currentUserId,
                      ),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppOrder>>(
      stream: context.read<AppState>().orderService.streamAllOrders(),
      initialData: context.read<AppState>().store.orders,
      builder: (context, snapshot) {
        final orders = snapshot.data ?? const <AppOrder>[];
        if (orders.isEmpty) {
          return const Center(child: Text('No platform orders yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: ListTile(
                title: Text(order.productName),
                subtitle: Text(
                  '${order.buyerEmail}\nQty ${order.quantity} • ${order.totalPrice.toStringAsFixed(0)} RWF',
                ),
                trailing: Chip(label: Text(order.status)),
              ),
            );
          },
        );
      },
    );
  }
}

class _CampaignTab extends StatefulWidget {
  const _CampaignTab();

  @override
  State<_CampaignTab> createState() => _CampaignTabState();
}

class _CampaignTabState extends State<_CampaignTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Broadcast to all users',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bodyCtrl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Message'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _sending
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _sending = true);
                          final ok = await context
                              .read<AppState>()
                              .sendCampaign(
                                title: _titleCtrl.text.trim(),
                                body: _bodyCtrl.text.trim(),
                              );
                          if (!mounted) return;
                          setState(() => _sending = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok
                                    ? 'Campaign sent to all users (simulated).'
                                    : 'Send failed',
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.campaign_outlined),
                  label: Text(_sending ? 'Sending...' : 'Send broadcast'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
