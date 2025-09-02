// shared/widgets/app_refresher.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AppRefresher extends ConsumerStatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefresher({super.key, required this.child, required this.onRefresh});

  @override
  ConsumerState<AppRefresher> createState() => _AppRefresherState();
}

class _AppRefresherState extends ConsumerState<AppRefresher> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    try {
      // Await the actual refresh logic passed from the parent.
      await widget.onRefresh();
      await Future.delayed(const Duration(milliseconds: 800));
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      header: const ClassicHeader(), // Or any other header you prefer
      child: widget.child,
    );
  }
}
