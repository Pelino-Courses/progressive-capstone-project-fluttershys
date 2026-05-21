import 'package:flutter/material.dart';

import '../screens/auth/sign_in_page.dart';

void promptSignIn(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Please sign in to continue'),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Sign in',
        onPressed: () => openSignIn(context),
      ),
    ),
  );
  Future<void>.delayed(const Duration(milliseconds: 500), () {
    if (context.mounted) openSignIn(context);
  });
}

void openSignIn(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const SignInPage()),
  );
}
