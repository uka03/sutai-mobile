import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/empty_state_view.dart';
import 'package:sutai/core/shared/refreshable_state_view.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/page/order/model/order_response.dart';
import 'package:sutai/page/order/provider/my_orders_provider.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(myOrdersProvider);
    return GeneralScaffold(
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(
        title: Text(
          'Миний захиалга',
          style: GeneralTextStyle.titleText(fontSize: 18),
        ),
      ),
      child: RefreshIndicator(
        color: GeneralColors.primaryColor,
        backgroundColor: GeneralColors.primaryBGColor,
        onRefresh: () async {
          ref.invalidate(myOrdersProvider);
          try {
            await ref.read(myOrdersProvider.future);
          } catch (_) {}
        },
        child: orders.when(
          loading: () =>
              const RefreshableStateView(child: CircularProgressIndicator()),
          error: (error, stackTrace) => RefreshableStateView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  apiErrorMessage(error, 'Захиалга татахад алдаа гарлаа.'),
                  style: GeneralTextStyle.bodyText(),
                ),
                VSpacer.sm(),
                TextButton(
                  onPressed: () => ref.invalidate(myOrdersProvider),
                  child: const Text('Дахин оролдох'),
                ),
              ],
            ),
          ),
          data: (response) => _OrdersList(response: response),
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.response});

  final MyOrdersResponse response;

  @override
  Widget build(BuildContext context) {
    if (response.data.isEmpty) {
      return RefreshableStateView(
        child: EmptyStateView(
          icon: Icons.receipt_long_outlined,
          title: 'Захиалга одоогоор алга',
          message: 'Таны хийсэн захиалгууд энд харагдана.',
          actionLabel: 'Бараа үзэх',
          onAction: () => context.go('/main'),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (response.meta?.total != null) ...[
            Text(
              'Нийт ${response.meta!.total} захиалга',
              style: GeneralTextStyle.bodyText(
                fontSize: 14,
                textColor: GeneralColors.textGrayColor,
              ),
            ),
            VSpacer(),
          ],
          for (final order in response.data) ...[
            _OrderCard(
              order: order,
              onTap: () => context.push('/orders/${order.id}'),
            ),
            VSpacer(),
          ],
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final OrderResponse order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (order.status) {
      OrderStatus.cancelled => GeneralColors.errorColor,
      OrderStatus.completed => GeneralColors.successColor,
      _ => GeneralColors.primaryColor,
    };

    return CustomButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GeneralColors.primaryBGColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: GeneralColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.number,
                    style: GeneralTextStyle.titleText(fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusLabel.text,
                    style: GeneralTextStyle.bodyText(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            VSpacer.xs(),
            Text(
              formatDate(order.createdAt, unknown: 'Огноо тодорхойгүй'),
              style: GeneralTextStyle.bodyText(
                textColor: GeneralColors.textGrayColor,
              ),
            ),
            VSpacer(),
            const Divider(height: 1, color: GeneralColors.borderColor),
            VSpacer(),
            _OrderInfoRow(
              icon: Icons.shopping_bag_outlined,
              text: '${order.itemsCount} бараа',
            ),
            VSpacer.sm(),
            _OrderInfoRow(icon: Icons.person_outline, text: order.customerName),
            VSpacer.sm(),
            _OrderInfoRow(
              icon: Icons.phone_outlined,
              text: order.customerPhone,
            ),
            VSpacer.sm(),
            _OrderInfoRow(
              icon: Icons.location_on_outlined,
              text: order.shippingAddress,
            ),
            if (order.note?.isNotEmpty == true) ...[
              VSpacer.sm(),
              _OrderInfoRow(icon: Icons.notes_outlined, text: order.note!),
            ],
            if (order.cancelledAt != null) ...[
              VSpacer.sm(),
              _OrderInfoRow(
                icon: Icons.event_busy_outlined,
                text:
                    'Цуцалсан: ${formatDate(order.cancelledAt, unknown: 'Огноо тодорхойгүй')}',
              ),
            ],
            VSpacer(),
            const Divider(height: 1, color: GeneralColors.borderColor),
            VSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Нийт төлбөр',
                  style: GeneralTextStyle.bodyText(fontSize: 14),
                ),
                Text(
                  formatPrice(order.total),
                  style: GeneralTextStyle.titleText(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class _OrderInfoRow extends StatelessWidget {
  const _OrderInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: GeneralColors.textGrayColor),
      HSpacer.sm(),
      Expanded(
        child: Text(
          text,
          style: GeneralTextStyle.bodyText(
            fontSize: 14,
            textColor: GeneralColors.textColor,
          ),
        ),
      ),
    ],
  );
}
