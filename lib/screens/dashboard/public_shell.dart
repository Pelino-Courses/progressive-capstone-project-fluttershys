import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../auth/sign_in_page.dart';
import '../auth/sign_up_page.dart';
import 'marketplace_page.dart';

class PublicShell extends StatelessWidget {
  const PublicShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Frutella Marketplace'),
            actions: [
              if (isWide) ...[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const SignInPage()),
                    );
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(width: 12),
              ] else
                IconButton(
                  tooltip: 'Sign in',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const SignInPage()),
                    );
                  },
                  icon: const Icon(Icons.login),
                ),
            ],
          ),
          body: constrainContent(
            const SafeArea(child: MarketplacePage(publicMode: true)),
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: 0,
                  onDestinationSelected: (index) {
                    if (index == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const SignInPage()),
                      );
                    }
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.storefront_outlined),
                      selectedIcon: Icon(Icons.storefront),
                      label: 'Browse',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Account',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
