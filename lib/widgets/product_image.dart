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
          child: imageUrl == null || imageUrl!.trim().isEmpty
              ? _placeholder(colorScheme)
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return _shimmerPlaceholder(colorScheme);
                  },
                  errorBuilder: (_, _, _) => _placeholder(colorScheme),
                ),
        ),
      ),
    );
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

  Widget _shimmerPlaceholder(ColorScheme colorScheme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainerHighest,
            colorScheme.surfaceContainerHigh,
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
    );
  }
}
