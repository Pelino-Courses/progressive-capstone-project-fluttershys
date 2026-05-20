import 'package:flutter/material.dart';

import 'empty_state.dart';
import 'loading_skeleton.dart';

typedef AsyncDataBuilder<T> = Widget Function(BuildContext context, T data);

class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.snapshot,
    required this.builder,
    this.loading,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.onRetry,
  });

  final AsyncSnapshot<T> snapshot;
  final AsyncDataBuilder<T> builder;
  final Widget? loading;
  final String emptyTitle;
  final String? emptyMessage;
  final IconData emptyIcon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return ErrorStateView(
        message: snapshot.error.toString(),
        onRetry: onRetry,
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      return loading ?? const Center(child: CircularProgressIndicator());
    }

    final data = snapshot.data;
    if (data == null) {
      return ErrorStateView(
        message: 'Unable to load data.',
        onRetry: onRetry,
      );
    }

    if (data is List && data.isEmpty) {
      return EmptyStateView(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
        actionLabel: onRetry == null ? null : 'Refresh',
        onAction: onRetry,
      );
    }

    return builder(context, data);
  }
}

class ProductListLoadingView extends StatelessWidget {
  const ProductListLoadingView({super.key, this.crossAxisCount = 2});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const LoadingSkeleton(height: 24, width: 180),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, _) => const SizedBox(
              width: 180,
              child: Card(child: LoadingSkeleton(borderRadius: 16)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const LoadingSkeleton(height: 24, width: 140),
        const SizedBox(height: 12),
        ProductGridSkeleton(crossAxisCount: crossAxisCount),
      ],
    );
  }
}
