import 'package:flutter/material.dart';

import 'admin_console_page.dart';

/// Landing dashboard for platform administrators.
class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Administration',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage users, catalog, campaigns, and monitor marketplace orders.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;
            final child = _DashboardCard(
              icon: Icons.group_outlined,
              title: 'Users & roles',
              subtitle: 'Promote buyers to vendors, assign admin, audit accounts.',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminConsolePage(initialTabIndex: 0),
                  ),
                );
              },
            );
            final child2 = _DashboardCard(
              icon: Icons.inventory_2_outlined,
              title: 'Catalog moderation',
              subtitle: 'View all listings, disable or remove products.',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminConsolePage(initialTabIndex: 1),
                  ),
                );
              },
            );
            final child3 = _DashboardCard(
              icon: Icons.campaign_outlined,
              title: 'Campaigns',
              subtitle: 'Send broadcast notifications to customers.',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminConsolePage(initialTabIndex: 2),
                  ),
                );
              },
            );
            final child4 = _DashboardCard(
              icon: Icons.dashboard_customize_outlined,
              title: 'Full console',
              subtitle: 'Open the tabbed admin console (all tools in one place).',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminConsolePage(),
                  ),
                );
              },
            );

            if (wide) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(width: (constraints.maxWidth - 12) / 2, child: child),
                  SizedBox(width: (constraints.maxWidth - 12) / 2, child: child2),
                  SizedBox(width: (constraints.maxWidth - 12) / 2, child: child3),
                  SizedBox(width: (constraints.maxWidth - 12) / 2, child: child4),
                ],
              );
            }
            return Column(
              children: [
                child,
                const SizedBox(height: 12),
                child2,
                const SizedBox(height: 12),
                child3,
                const SizedBox(height: 12),
                child4,
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Buyer testing'),
            subtitle: const Text(
              'Use Shop and Cart in this app to place test orders as admin; they appear under All orders.',
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
