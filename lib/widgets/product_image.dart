import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.imageUrl,
    this.aspectRatio = 4 / 3,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
  });

  final String? imageUrl;
  final double aspectRatio;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: colorScheme.surfaceContainerHighest,
          child: _buildImage(colorScheme),
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme) {
    final path = imageUrl?.trim();
    if (path == null || path.isEmpty) {
      return _placeholder(colorScheme);
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(colorScheme),
      );
    }

    if (!kIsWeb && (path.startsWith('/') || path.contains(':\\'))) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(colorScheme),
        );
      }
    }

    return _placeholder(colorScheme);
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.local_grocery_store_outlined,
        size: 40,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
      ),
    );
  }
}
