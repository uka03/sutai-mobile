import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:sutai/core/shared/toasts.dart';
import 'package:sutai/page/order/model/order_action_exception.dart';
import 'package:sutai/page/order/components/order_line_item.dart';
import 'package:sutai/page/order/components/order_cancel_dialog.dart';
import 'package:sutai/page/order/model/order_detail_response.dart';
import 'package:sutai/page/order/model/order_response.dart';
import 'package:sutai/page/order/provider/my_orders_provider.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.orderId});

  static const path = '/orders/:id';

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(orderDetailProvider(orderId));
    return GeneralScaffold(
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(
        title: Text(
          'Захиалгын дэлгэрэнгүй',
          style: GeneralTextStyle.titleText(fontSize: 18),
        ),
      ),
      child: RefreshIndicator(
        color: GeneralColors.primaryColor,
        backgroundColor: GeneralColors.primaryBGColor,
        onRefresh: () async {
          ref.invalidate(orderDetailProvider(orderId));
          try {
            await ref.read(orderDetailProvider(orderId).future);
          } catch (_) {}
        },
        child: detail.when(
          loading: () =>
              const RefreshableStateView(child: CircularProgressIndicator()),
          error: (error, stackTrace) => RefreshableStateView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  apiErrorMessage(
                    error,
                    'Захиалгын мэдээлэл татахад алдаа гарлаа.',
                  ),
                  style: GeneralTextStyle.bodyText(),
                  textAlign: TextAlign.center,
                ),
                VSpacer.sm(),
                TextButton(
                  onPressed: () => ref.invalidate(orderDetailProvider(orderId)),
                  child: const Text('Дахин оролдох'),
                ),
              ],
            ),
          ),
          data: (order) => _OrderDetailContent(order: order),
        ),
      ),
    );
  }
}

class _OrderDetailContent extends ConsumerStatefulWidget {
  const _OrderDetailContent({required this.order});

  final OrderDetailData order;

  @override
  ConsumerState<_OrderDetailContent> createState() =>
      _OrderDetailContentState();
}

class _OrderDetailContentState extends ConsumerState<_OrderDetailContent> {
  bool _isCancelling = false;

  Future<void> _cancelOrder() async {
    final confirmed = await OrderCancelDialog.show(context);
    if (confirmed != true || !mounted) return;

    setState(() => _isCancelling = true);
    try {
      await ref.read(orderActionsProvider).cancelOrder(widget.order.id);
      if (!mounted) return;
      Toast.success(context, description: 'Захиалга цуцлагдлаа.');
    } catch (error) {
      if (!mounted) return;
      final message = error is OrderActionException
          ? error.message
          : 'Захиалгыг цуцлахад алдаа гарлаа.';
      Toast.error(context, description: message);
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final statusColor = switch (order.status) {
      OrderStatus.cancelled => GeneralColors.errorColor,
      OrderStatus.completed => GeneralColors.successColor,
      _ => GeneralColors.primaryColor,
    };

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: GeneralColors.primaryBGColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: GeneralColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.number,
                  style: GeneralTextStyle.titleText(fontSize: 20),
                ),
                VSpacer.sm(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusLabel.text,
                    style: GeneralTextStyle.bodyText(
                      fontWeight: FontWeight.w600,
                      textColor: statusColor,
                    ),
                  ),
                ),
                VSpacer.sm(),
                Text(
                  'Үүсгэсэн: ${formatDate(order.createdAt)}',
                  style: GeneralTextStyle.bodyText(
                    textColor: GeneralColors.textGrayColor,
                  ),
                ),
                if (order.cancelledAt != null) ...[
                  VSpacer.xs(),
                  Text(
                    'Цуцалсан: ${formatDate(order.cancelledAt)}',
                    style: GeneralTextStyle.bodyText(
                      textColor: GeneralColors.errorColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          VSpacer.lg(),
          if (order.status == OrderStatus.pending) ...[
            CustomButton(
              onTap: _cancelOrder,
              enabled: !_isCancelling,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: GeneralColors.errorColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: _isCancelling
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GeneralColors.errorColor,
                          ),
                        )
                      : Text(
                          'Захиалга цуцлах',
                          style: GeneralTextStyle.titleText(
                            fontSize: 15,
                            textColor: GeneralColors.errorColor,
                          ),
                        ),
                ),
              ),
            ),
            VSpacer.lg(),
          ],
          Text(
            'Захиалсан бараа',
            style: GeneralTextStyle.titleText(fontSize: 17),
          ),
          VSpacer.sm(),
          if (order.items.isEmpty)
            const EmptyStateView(
              icon: Icons.inventory_2_outlined,
              title: 'Барааны мэдээлэл алга',
              message: 'Захиалгад хамаарах бүтээгдэхүүний мэдээлэл олдсонгүй.',
              compact: true,
            )
          else
            for (final item in order.items) ...[
              OrderLineItem(item: item),
              VSpacer.sm(),
            ],
          VSpacer(),
          Text(
            'Хүргэлтийн мэдээлэл',
            style: GeneralTextStyle.titleText(fontSize: 17),
          ),
          VSpacer.sm(),
          _DetailPanel(
            children: [
              _InfoRow(
                icon: Icons.person_outline,
                label: 'Хүлээн авагч',
                value: order.customerName,
              ),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Утас',
                value: order.customerPhone,
              ),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Хаяг',
                value: order.shippingAddress,
              ),
              if (order.note?.isNotEmpty == true)
                _InfoRow(
                  icon: Icons.notes_outlined,
                  label: 'Нэмэлт тэмдэглэл',
                  value: order.note!,
                ),
            ],
          ),
          VSpacer.lg(),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: GeneralColors.primaryBGColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: GeneralColors.borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Нийт төлбөр',
                  style: GeneralTextStyle.titleText(fontSize: 16),
                ),
                Text(
                  formatPrice(order.total),
                  style: GeneralTextStyle.titleText(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: GeneralColors.primaryBGColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: GeneralColors.borderColor),
    ),
    child: Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) ...[VSpacer.sm(), const Divider(height: 1)],
          children[index],
        ],
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: GeneralColors.textGrayColor),
        HSpacer.sm(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GeneralTextStyle.bodyText(
                  textColor: GeneralColors.textGrayColor,
                ),
              ),
              VSpacer.xs(),
              Text(value, style: GeneralTextStyle.titleText(fontSize: 14)),
            ],
          ),
        ),
      ],
    ),
  );
}
