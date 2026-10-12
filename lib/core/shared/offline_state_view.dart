import 'package:flutter/material.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';

class OfflineStateView extends StatelessWidget {
  const OfflineStateView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => RefreshableStateView(
    child: EmptyStateView(
      icon: Icons.wifi_off_rounded,
      title: 'Интернэт холболтгүй байна',
      message: 'Холболтоо шалгаад дахин оролдоно уу.',
      actionLabel: 'Дахин оролдох',
      onAction: onRetry,
      compact: true,
    ),
  );
}
