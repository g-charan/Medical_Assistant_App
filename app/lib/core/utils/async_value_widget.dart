// lib/data/presentation/widgets/shared/async_value_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A reusable widget to handle the states of an AsyncValue.
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? loading;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.error,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      // Use the provided loading widget, or default to a CircularProgressIndicator.
      loading:
          loading ??
          () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
      // Use the provided error widget, or default to a simple text display.
      error:
          error ??
          (e, st) => SliverFillRemaining(
            child: Center(child: Text('An error occurred: $e')),
          ),
    );
  }
}
