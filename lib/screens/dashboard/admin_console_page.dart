import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/app_state.dart';

class AdminConsolePage extends StatelessWidget {
  const AdminConsolePage({super.key, this.initialTabIndex = 0});

  /// 0 = Users, 1 = All products, 2 = Campaigns
  final int initialTabIndex;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (!appState.isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Access denied. Admin only.')),
      );
    }

    final tabIndex = initialTabIndex.clamp(0, 2);

    return DefaultTabController(
      length: 3,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Console'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'All Products'),
              Tab(text: 'Campaigns'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_UsersTab(), _AllProductsTab(), _CampaignTab()],
        ),
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<AppState>().firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? const [];

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();
            final uid = (data['uid'] as String?) ?? docs[index].id;
            final role = (data['role'] as String?) ?? 'buyer';

            return Card(
              child: ListTile(
                title: Text((data['displayName'] as String?) ?? 'Unknown'),
                subtitle: Text((data['email'] as String?) ?? 'No email'),
                trailing: DropdownButton<String>(
                  value: role == 'user' ? 'buyer' : role,
                  items: const [
                    DropdownMenuItem(value: 'buyer', child: Text('buyer')),
                    DropdownMenuItem(value: 'vendor', child: Text('vendor')),
                    DropdownMenuItem(value: 'admin', child: Text('admin')),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    final appState = context.read<AppState>();
                    final ok = await appState.setUserRole(
                      targetUid: uid,
                      role: value,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? 'Role updated for ${(data['displayName'] as String?) ?? uid}'
                                : 'Role update failed',
                          ),
                        ),
                      );
                    }
                  },
                ),
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
        constraints: const BoxConstraints(maxWidth: 700),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Broadcast Campaign Notification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bodyCtrl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Body'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Message body is required';
                    }
                    return null;
                  },
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
                                    ? 'Campaign sent successfully.'
                                    : 'Campaign send failed.',
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.campaign),
                  label: Text(_sending ? 'Sending...' : 'Send Campaign'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AllProductsTab extends StatelessWidget {
  const _AllProductsTab();

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return StreamBuilder<List<Product>>(
      stream: appState.productService.streamAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? const <Product>[];

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            return Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(
                  'Owner: ${product.ownerName} • ${product.price.toStringAsFixed(0)} RWF',
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: product.isAvailable ? 'Disable' : 'Enable',
                      onPressed: () async {
                        final updated = product.copyWith(
                          isAvailable: !product.isAvailable,
                        );
                        await appState.productService.updateProduct(
                          product: updated,
                          isAdmin: true,
                          currentUserId: appState.currentUserId,
                        );
                      },
                      icon: Icon(
                        product.isAvailable
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () async {
                        await appState.productService.deleteProduct(
                          productId: product.id,
                          productOwnerId: product.ownerId,
                          isAdmin: true,
                          currentUserId: appState.currentUserId,
                        );
                      },
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
